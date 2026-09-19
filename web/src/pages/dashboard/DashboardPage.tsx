import { useCallback, useEffect, useState } from 'react'
import { Link } from 'react-router-dom'

import { ErrorState } from '../../components/shared/ViewState'
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

  return (
    <div className="page-stack">
      <section className="welcome-banner" aria-label="Workspace overview">
        <div className="welcome-banner-content">
          <p className="eyebrow">Workspace overview</p>
          <h1>Good day, {user?.name}</h1>
          <p>Review current workload, health updates, and access your next permitted task.</p>
        </div>
        <div className="live-status-pill">
          <span className="pulse-dot" aria-hidden="true" />
          <span>{isDoctor ? 'VERIFIED' : 'ACTIVE'}</span>
        </div>
      </section>

      {status === 'loading' ? (
        <div className="skeleton-grid" role="status" aria-label="Loading workspace summary">
          <div className="skeleton-card" />
          <div className="skeleton-card" />
          <div className="skeleton-card" />
        </div>
      ) : status === 'error' ? (
        <ErrorState message="Workspace summary could not be loaded." onRetry={() => void load()} />
      ) : (
        <section className="metric-grid" aria-label="Workspace summary">
          <article className="metric-card metric-card--teal">
            <div className="metric-card-top">
              <span>Open items</span>
              <span className="metric-icon-badge metric-icon-badge--teal" aria-hidden="true">📋</span>
            </div>
            <strong>{metrics?.first ?? 0}</strong>
            <small>Within your permitted scope</small>
          </article>
          <article className="metric-card metric-card--amber">
            <div className="metric-card-top">
              <span>Awaiting review</span>
              <span className="metric-icon-badge metric-icon-badge--amber" aria-hidden="true">⏳</span>
            </div>
            <strong>{metrics?.second ?? 0}</strong>
            <small>Requires authorized action</small>
          </article>
          <article className="metric-card metric-card--blue">
            <div className="metric-card-top">
              <span>{isDoctor ? 'Approved' : 'Records visible'}</span>
              <span className="metric-icon-badge metric-icon-badge--blue" aria-hidden="true">🛡️</span>
            </div>
            <strong>{metrics?.third ?? 0}</strong>
            <small>Access-controlled data</small>
          </article>
        </section>
      )}

      <section className="panel">
        <div className="panel-heading">
          <div>
            <p className="eyebrow">Next actions</p>
            <h2>Continue your work</h2>
          </div>
        </div>
        <div className="action-grid">
          {isDoctor ? (
            <>
              <Link className="action-card action-card--teal" to="/cases">
                <div className="action-card-header">
                  <strong>Review triage queue</strong>
                  <span className="action-card-arrow" aria-hidden="true">→</span>
                </div>
                <span>Open verified case grants and structured context.</span>
              </Link>
              <Link className="action-card action-card--blue" to="/approvals">
                <div className="action-card-header">
                  <strong>Complete approvals</strong>
                  <span className="action-card-arrow" aria-hidden="true">→</span>
                </div>
                <span>Review validated drafts awaiting clinical decision.</span>
              </Link>
            </>
          ) : (
            <>
              <Link className="action-card action-card--teal" to="/records">
                <div className="action-card-header">
                  <strong>Browse records</strong>
                  <span className="action-card-arrow" aria-hidden="true">→</span>
                </div>
                <span>Search permitted family record summaries.</span>
              </Link>
              {user?.role !== 'MEMBER' && (
                <Link className="action-card action-card--blue" to="/audit">
                  <div className="action-card-header">
                    <strong>Review access history</strong>
                    <span className="action-card-arrow" aria-hidden="true">→</span>
                  </div>
                  <span>See who accessed permitted information.</span>
                </Link>
              )}
            </>
          )}
        </div>
      </section>
    </div>
  )
}
