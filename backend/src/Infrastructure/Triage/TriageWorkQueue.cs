using System.Threading.Channels;
using FamilyVeda.Application.Triage;

namespace FamilyVeda.Infrastructure.Triage;

public sealed class TriageWorkQueue : ITriageWorkQueue
{
    private readonly Channel<Guid> _queue = Channel.CreateBounded<Guid>(new BoundedChannelOptions(100)
    {
        FullMode = BoundedChannelFullMode.Wait,
        SingleReader = true,
        SingleWriter = false
    });

    public ValueTask QueueAsync(Guid caseId, CancellationToken cancellationToken) => _queue.Writer.WriteAsync(caseId, cancellationToken);
    public ValueTask<Guid> DequeueAsync(CancellationToken cancellationToken) => _queue.Reader.ReadAsync(cancellationToken);
}
