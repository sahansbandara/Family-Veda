using FamilyVeda.Application.Triage;

namespace FamilyVeda.Api.Background;

public sealed class CaseSlaWorker(IServiceScopeFactory scopeFactory, ILogger<CaseSlaWorker> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        using var timer = new PeriodicTimer(TimeSpan.FromMinutes(1));
        do
        {
            try
            {
                await using var scope = scopeFactory.CreateAsyncScope();
                await scope.ServiceProvider.GetRequiredService<ICaseSlaProcessor>().ProcessOverdueCasesAsync(stoppingToken);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested) { break; }
            catch (Exception exception) { logger.LogError(exception, "Case SLA scan failed."); }
        } while (await timer.WaitForNextTickAsync(stoppingToken));
    }
}
