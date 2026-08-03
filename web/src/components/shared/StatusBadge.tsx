type StatusTone = 'muted' | 'primary' | 'warning' | 'success' | 'danger' | 'agent'

const toneByStatus: Record<string, StatusTone> = {
  SUBMITTED: 'muted',
  PENDING_DOCTOR_REVIEW: 'primary',
  AWAITING_INFO: 'warning',
  APPROVED: 'success',
  VERIFIED: 'success',
  REJECTED: 'danger',
  DRAFT: 'agent',
}

export function StatusBadge({ status }: { status: string }) {
  const tone = toneByStatus[status] ?? 'muted'
  const label = status.replaceAll('_', ' ')

  return (
    <span className={`status-badge status-badge--${tone}`}>
      <span aria-hidden="true">●</span>
      {label}
    </span>
  )
}
