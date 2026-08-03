import { Link } from 'react-router-dom'

export function AccessDeniedPage() {
  return <main className="centered-page"><p className="eyebrow">Permission check</p><h1>Access unavailable</h1><p>Your current role does not permit this workspace.</p><Link className="button button--primary" to="/dashboard">Return to dashboard</Link></main>
}

export function NotFoundPage() {
  return <main className="centered-page"><p className="eyebrow">404</p><h1>Page not found</h1><p>The requested page does not exist.</p><Link className="button button--primary" to="/dashboard">Return to dashboard</Link></main>
}
