import { useCallback, useEffect, useState } from 'react'
import { Link } from 'react-router-dom'

import { StatusBadge } from '../../components/shared/StatusBadge'
import { ErrorState, LoadingState } from '../../components/shared/ViewState'
import { apiClient, type FamilyDashboardDto, type FamilyDto, type PagedResult, type TriageCaseDto } from '../../services/apiClient'
import { useAppSelector } from '../../store/hooks'

type Metrics = { first: number; second: number; third: number }

export function DashboardPage() {
  const user = useAppSelector((state) => state.auth.user)
  const isDoctor = user?.role === 'DOCTOR'
  const [metrics, setMetrics] = useState<Metrics | null>(null)
  const [status, setStatus] = useState<'loading' | 'ready' | 'error'>('loading')
  const load = useCallback(async () => {
    setStatus('loading')
    try {
      if (isDoctor) {
        const { data } = await apiClient.get<PagedResult<TriageCaseDto>>('/doctors/me/cases', { params: { page: 1, pageSize: 100 } })
        setMetrics({ first: data.totalCount, second: data.items.filter((item) => item.status === 'PendingDoctorReview').length, third: data.items.filter((item) => item.status.startsWith('Approved')).length })
      } else if (user?.role === 'ADMIN') {
        const { data } = await apiClient.get<PagedResult<unknown>>('/admin/doctors', { params: { page: 1, pageSize: 1 } })
        setMetrics({ first: data.totalCount, second: data.totalCount, third: 0 })
      } else {
        const family = (await apiClient.get<FamilyDto>('/families/me')).data
        const { data } = await apiClient.get<FamilyDashboardDto>(`/families/${family.id}/dashboard`)
        setMetrics({ first: data.openCases, second: data.awaitingDoctorReview, third: data.recordsCount })
      }
      setStatus('ready')
    } catch { setStatus('error') }
  }, [isDoctor, user?.role])
  useEffect(() => { void load() }, [load])

  return <div className="page-stack">
    <header className="page-header"><div><p className="eyebrow">Workspace overview</p><h1>Good day, {user?.name}</h1><p>Review current workload and access your next permitted task.</p></div><StatusBadge status={isDoctor ? 'VERIFIED' : 'ACTIVE'} /></header>
    {status === 'loading' ? <LoadingState label="Loading workspace summary" /> : status === 'error' ? <ErrorState message="Workspace summary could not be loaded." onRetry={() => void load()} /> : <section className="metric-grid" aria-label="Workspace summary">
      <article className="metric-card"><span>Open items</span><strong>{metrics?.first ?? 0}</strong><small>Within your permitted scope</small></article>
      <article className="metric-card"><span>Awaiting review</span><strong>{metrics?.second ?? 0}</strong><small>Requires authorized action</small></article>
      <article className="metric-card"><span>{isDoctor ? 'Approved' : 'Records visible'}</span><strong>{metrics?.third ?? 0}</strong><small>Access-controlled data</small></article>
    </section>}
    <section className="panel"><div className="panel-heading"><div><p className="eyebrow">Next actions</p><h2>Continue your work</h2></div></div><div className="action-grid">
      {isDoctor ? <><Link className="action-card" to="/cases"><strong>Review triage queue</strong><span>Open verified case grants and structured context.</span></Link><Link className="action-card" to="/approvals"><strong>Complete approvals</strong><span>Review validated drafts awaiting clinical decision.</span></Link></> : <><Link className="action-card" to="/records"><strong>Browse records</strong><span>Search permitted family record summaries.</span></Link>{user?.role !== 'MEMBER' && <Link className="action-card" to="/audit"><strong>Review access history</strong><span>See who accessed permitted information.</span></Link>}</>}
    </div></section>
  </div>
}
