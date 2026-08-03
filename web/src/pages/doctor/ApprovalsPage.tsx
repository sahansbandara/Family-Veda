import { useCallback, useEffect, useState } from 'react'

import { StatusBadge } from '../../components/shared/StatusBadge'
import { EmptyState, ErrorState, LoadingState } from '../../components/shared/ViewState'
import { apiClient, type CaseReviewDto, type PagedResult, type TriageCaseDto } from '../../services/apiClient'

const approvedGuidance = [
  'Please arrange an in-person clinical review.',
  'Please discuss appropriate screening with a licensed clinician.',
  'Continue monitoring symptoms and seek in-person care if they worsen.',
] as const

export function ApprovalsPage() {
  const [cases, setCases] = useState<TriageCaseDto[]>([])
  const [selectedId, setSelectedId] = useState('')
  const [review, setReview] = useState<CaseReviewDto | null>(null)
  const [advisory, setAdvisory] = useState('')
  const [notes, setNotes] = useState('')
  const [status, setStatus] = useState<'loading' | 'ready' | 'error'>('loading')
  const [reviewStatus, setReviewStatus] = useState<'idle' | 'loading' | 'ready' | 'error'>('idle')
  const [saving, setSaving] = useState(false)
  const [message, setMessage] = useState('')

  const loadQueue = useCallback(async () => {
    setStatus('loading')
    try {
      const { data } = await apiClient.get<PagedResult<TriageCaseDto>>('/doctors/me/cases', { params: { page: 1, pageSize: 100 } })
      const actionable = data.items.filter((item) => ['PendingDoctorReview', 'LowConfidence', 'Claimed'].includes(item.status))
      setCases(actionable)
      setSelectedId((current) => current || actionable[0]?.id || '')
      setStatus('ready')
    } catch { setStatus('error') }
  }, [])
  useEffect(() => { void loadQueue() }, [loadQueue])
  const loadReview = useCallback(async () => {
    if (!selectedId) { setReview(null); setReviewStatus('idle'); return }
    setReview(null); setReviewStatus('loading'); setMessage('')
    try {
      const { data } = await apiClient.get<CaseReviewDto>(`/triage-cases/${selectedId}/review`)
      setReview(data); setAdvisory(''); setNotes(''); setReviewStatus('ready')
    } catch { setReviewStatus('error') }
  }, [selectedId])
  useEffect(() => { void loadReview() }, [loadReview])

  async function decide(action: 'approve' | 'revise' | 'request-info' | 'reject' | 'escalate') {
    if (!selectedId || saving) return
    if ((action === 'approve' || action === 'revise') && !approvedGuidance.includes(advisory as (typeof approvedGuidance)[number])) { setMessage('Select approved non-diagnostic patient guidance.'); return }
    if (!window.confirm(`Confirm ${action.replace('-', ' ')} decision? This action is audited.`)) return
    setSaving(true); setMessage('')
    try {
      await apiClient.post(`/triage-cases/${selectedId}/${action}`, { doctorNotes: notes.trim() || null, finalAdvisory: advisory.trim() || null })
      setMessage('Decision saved and patient visibility updated through approval gate.')
      setSelectedId(''); setReview(null); await loadQueue()
    } catch { setMessage('Decision was not saved. Review access, wording, and safety validation, then retry.') }
    finally { setSaving(false) }
  }

  return <div className="page-stack">
    <header className="page-header"><div><p className="eyebrow">Clinical review gate</p><h1>Approvals</h1><p>Structured AI output remains doctor-only until an authorized decision is saved.</p></div></header>
    {status === 'loading' ? <LoadingState label="Loading approval queue" /> : status === 'error' ? <ErrorState message="Approval queue could not be loaded." onRetry={() => void loadQueue()} /> : cases.length === 0 ? <EmptyState title="No cases awaiting approval" message="Cases appear here only with an active grant and pending doctor review." /> : <>
      <label>Case<select value={selectedId} onChange={(event) => setSelectedId(event.target.value)}>{cases.map((item) => <option key={item.id} value={item.id}>{item.id} · {item.priority}</option>)}</select></label>
      {reviewStatus === 'error' ? <ErrorState message="Case evidence could not be loaded." onRetry={() => void loadReview()} /> : reviewStatus !== 'ready' || !review ? <LoadingState label="Loading case evidence" /> : <section className="approval-layout">
        <article className="panel agent-panel"><div className="panel-heading"><div><p className="eyebrow">Unapproved structured output</p><h2>{review.id}</h2></div><StatusBadge status="DRAFT" /></div>
          <dl className="detail-list"><div><dt>Priority</dt><dd>{review.priority}</dd></div><div><dt>Status</dt><dd>{review.status}</dd></div><div><dt>Trace steps</dt><dd>{review.traces.length}</dd></div></dl>
          <h3>Analysis</h3><pre className="agent-copy">{review.analysisJson ?? 'No analysis output.'}</pre><h3>Familial screening signal</h3><pre className="agent-copy">{review.familialRiskJson ?? 'No consented familial signal.'}</pre>
          <h3>Agent traces</h3><div className="table-scroll"><table><thead><tr><th>Step</th><th>Agent</th><th>Tools allowed</th><th>Denied</th><th>Confidence</th></tr></thead><tbody>{review.traces.map((trace) => <tr key={`${trace.stepNumber}-${trace.agent}`}><td>{trace.stepNumber}</td><td>{trace.agent}</td><td>{trace.toolsAllowed.join(', ') || 'None'}</td><td>{trace.toolsDenied.join(', ') || 'None'}</td><td>{trace.confidence.toFixed(2)}</td></tr>)}</tbody></table></div>
        </article>
        <aside className="panel approval-panel" aria-labelledby="decision-heading"><p className="eyebrow">Doctor decision</p><h2 id="decision-heading">Review actions</h2>
          <label>Final patient guidance<select value={advisory} onChange={(event) => setAdvisory(event.target.value)}><option value="">Select approved guidance</option>{approvedGuidance.map((guidance) => <option key={guidance} value={guidance}>{guidance}</option>)}</select></label><label>Internal notes<textarea rows={4} value={notes} onChange={(event) => setNotes(event.target.value)} maxLength={1000} /></label>
          {message && <p role="status">{message}</p>}<div className="button-stack"><button type="button" className="button button--primary" disabled={saving} onClick={() => void decide('approve')}>Approve</button><button type="button" className="button button--secondary" disabled={saving} onClick={() => void decide('revise')}>Revise and approve</button><button type="button" className="button button--secondary" disabled={saving} onClick={() => void decide('request-info')}>Request information</button><button type="button" className="button button--danger" disabled={saving} onClick={() => void decide('reject')}>Reject</button><button type="button" className="button button--danger" disabled={saving} onClick={() => void decide('escalate')}>Escalate</button></div>
        </aside>
      </section>}
    </>}
  </div>
}
