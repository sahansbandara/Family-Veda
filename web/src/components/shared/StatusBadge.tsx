type StatusTone = 'muted' | 'primary' | 'warning' | 'success' | 'danger' | 'agent'

const toneByStatus: Record<string, StatusTone> = {
  ACTIVE: 'success',
  SUBMITTED: 'muted',
  PENDING_DOCTOR_REVIEW: 'primary',
  PendingDoctorReview: 'primary',
  AWAITING_INFO: 'warning',
  PendingReaffirmation: 'warning',
  APPROVED: 'success',
  Approved: 'success',
  VERIFIED: 'success',
  Granted: 'success',
  CONFIRMED: 'success',
  Success: 'success',
  REJECTED: 'danger',
  Escalated: 'danger',
  Failure: 'danger',
  REVIEW_REQUIRED: 'warning',
  DRAFT: 'agent',
}

export function StatusBadge({ status }: { status: string }) {
  const tone = toneByStatus[status] ?? 'muted'
  const label = status.replaceAll('_', ' ')

  return (
    <span className={`status-badge status-badge--${tone}`}>
      {label}
    </span>
  )
}
