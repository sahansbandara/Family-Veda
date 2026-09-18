using System.Net.Http.Headers;
using System.Net.Http.Json;
using FamilyVeda.Application.Triage;
using Google.Apis.Auth.OAuth2;
using Microsoft.Extensions.Configuration;

namespace FamilyVeda.Infrastructure.Triage;

public sealed class FcmPushNotificationClient(HttpClient httpClient, IConfiguration configuration) : IPushNotificationClient
{
    private const string MessagingScope = "https://www.googleapis.com/auth/firebase.messaging";

    public async Task SendAsync(IReadOnlyCollection<string> deviceTokens, string eventType, IReadOnlyDictionary<string, string> metadata, CancellationToken cancellationToken)
    {
        var projectId = configuration["Fcm:ProjectId"];
        var serviceAccountJson = configuration["Fcm:ServiceAccountJson"];
        if (string.IsNullOrWhiteSpace(projectId) || string.IsNullOrWhiteSpace(serviceAccountJson)) return;

        var credential = CredentialFactory.FromJson<ServiceAccountCredential>(serviceAccountJson)
            .ToGoogleCredential()
            .CreateScoped(MessagingScope);
        var accessToken = await credential.UnderlyingCredential.GetAccessTokenForRequestAsync(cancellationToken: cancellationToken);

        var failures = 0;
        foreach (var token in deviceTokens)
        {
            using var request = new HttpRequestMessage(HttpMethod.Post, $"v1/projects/{Uri.EscapeDataString(projectId)}/messages:send");
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            request.Content = JsonContent.Create(new
            {
                message = new
                {
                    token,
                    data = metadata.Append(new KeyValuePair<string, string>("eventType", eventType)).ToDictionary()
                }
            });
            // One stale or invalid device token must not stop delivery to the recipient's other devices.
            try
            {
                using var response = await httpClient.SendAsync(request, cancellationToken);
                if (!response.IsSuccessStatusCode) failures++;
            }
            catch (Exception exception) when (exception is HttpRequestException or TaskCanceledException && !cancellationToken.IsCancellationRequested)
            {
                failures++;
            }
        }

        if (failures > 0)
            throw new HttpRequestException($"FCM delivery failed for {failures} of {deviceTokens.Count} device token(s).");
    }
}
