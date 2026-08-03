import { NavLink, Outlet } from 'react-router-dom'

import { useAppDispatch, useAppSelector } from '../../store/hooks'
import { signedOut } from '../../store/slices/authSlice'
import type { UserRole } from '../../store/slices/authSlice'
import { apiClient } from '../../services/apiClient'

type NavItem = {
  label: string
  path: string
  roles: UserRole[]
}

const navItems: NavItem[] = [
  { label: 'Verification status', path: '/doctor-status', roles: ['DOCTOR'] },
  { label: 'Dashboard', path: '/dashboard', roles: ['DOCTOR', 'ADMIN', 'FAMILY_HEAD', 'MEMBER'] },
  { label: 'Records', path: '/records', roles: ['FAMILY_HEAD', 'MEMBER'] },
  { label: 'Family', path: '/family', roles: ['FAMILY_HEAD'] },
  { label: 'Triage cases', path: '/cases', roles: ['DOCTOR'] },
  { label: 'Approvals', path: '/approvals', roles: ['DOCTOR'] },
  { label: 'Audit', path: '/audit', roles: ['ADMIN', 'FAMILY_HEAD'] },
  { label: 'Doctor verification', path: '/doctor-verification', roles: ['ADMIN'] },
]

export function AppLayout() {
  const dispatch = useAppDispatch()
  const user = useAppSelector((state) => state.auth.user)
  const visibleItems = navItems.filter((item) => user && item.roles.includes(user.role) &&
    (user.role !== 'DOCTOR' || user.verificationStatus === 'VERIFIED' || item.path === '/doctor-status'))
  async function signOut() {
    try { await apiClient.post('/auth/logout') }
    finally { dispatch(signedOut()) }
  }

  return (
    <div className="app-shell">
      <a className="skip-link" href="#main-content">Skip to main content</a>
      <header className="topbar">
        <NavLink className="brand" to={user?.role === 'ONBOARDING' ? '/onboarding' : '/dashboard'} aria-label="Family Veda dashboard">
          <span className="brand-mark" aria-hidden="true">FV</span>
          <span>
            <strong>Family Veda</strong>
            <small>Clinical workspace</small>
          </span>
        </NavLink>
        <div className="session-summary">
          <span>
            <strong>{user?.name}</strong>
            <small>{user?.role.replaceAll('_', ' ')}</small>
          </span>
          <button type="button" className="button button--secondary" onClick={() => void signOut()}>
            Sign out
          </button>
        </div>
      </header>
      <nav className="primary-nav" aria-label="Primary navigation">
        {visibleItems.map((item) => (
          <NavLink key={item.path} to={item.path} className={({ isActive }) => isActive ? 'active' : undefined}>
            {item.label}
          </NavLink>
        ))}
      </nav>
      <main id="main-content" className="main-content" tabIndex={-1}>
        <Outlet />
      </main>
      <footer className="app-footer">
        Clinical decision-support workspace. Access is controlled and activity is audited.
      </footer>
    </div>
  )
}
