import { useState } from 'react'
import type { FormEvent } from 'react'
import { Link, Navigate, useLocation, useNavigate } from 'react-router-dom'
import { z } from 'zod'

import { useAppDispatch, useAppSelector } from '../../store/hooks'
import { signIn } from '../../store/slices/authSlice'

const signInSchema = z.object({
  email: z.string().email('Enter a valid email address.'),
  password: z.string().min(1, 'Enter your password.'),
})

export function LoginPage() {
  const dispatch = useAppDispatch()
  const navigate = useNavigate()
  const location = useLocation()
  const isAuthenticated = useAppSelector((state) => state.auth.isAuthenticated)
  const authStatus = useAppSelector((state) => state.auth.status)
  const authError = useAppSelector((state) => state.auth.error)
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')

  if (isAuthenticated) {
    return <Navigate to="/dashboard" replace />
  }

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const parsed = signInSchema.safeParse({ email, password })

    if (!parsed.success) {
      setError(parsed.error.issues[0]?.message ?? 'Check the form and try again.')
      return
    }

    const result = await dispatch(signIn(parsed.data))
    if (signIn.rejected.match(result)) return

    const destination = result.payload.role === 'ONBOARDING' ? '/onboarding' : result.payload.role === 'DOCTOR' && result.payload.verificationStatus !== 'VERIFIED' ? '/doctor-status' : (location.state as { from?: string } | null)?.from ?? '/dashboard'
    navigate(destination, { replace: true })
  }

  return (
    <main className="login-page">
      <section className="login-intro" aria-labelledby="login-title">
        <span className="brand-mark brand-mark--large" aria-hidden="true">FV</span>
        <p className="eyebrow">Family Veda</p>
        <h1 id="login-title">Clinical context, ready for review.</h1>
        <p>A secure workspace for family health records, triage review, approvals, and access auditing.</p>
        <div className="trust-note">
          <strong>Review gate enforced</strong>
          <span>Patient-visible guidance requires licensed doctor approval.</span>
        </div>
      </section>
      <section className="login-card" aria-labelledby="sign-in-heading">
        <p className="eyebrow">Workspace access</p>
        <h2 id="sign-in-heading">Sign in</h2>
        <p className="muted">Use a synthetic account created through the Family Veda API.</p>
        <form onSubmit={handleSubmit} noValidate>
          <label className="field">
            <span>Email address</span>
            <input
              type="email"
              autoComplete="email"
              value={email}
              aria-describedby={error ? 'login-error' : undefined}
              onChange={(event) => setEmail(event.target.value)}
            />
          </label>
          <label className="field">
            <span>Password</span>
            <input type="password" autoComplete="current-password" value={password} onChange={(event) => setPassword(event.target.value)} />
          </label>
          {(error || authError) && <p id="login-error" className="form-error" role="alert">{error || authError}</p>}
          <button type="submit" disabled={authStatus === 'loading'} className="button button--primary button--full">
            {authStatus === 'loading' ? 'Signing in…' : 'Continue securely'}
          </button>
        </form>
        <p className="privacy-note">Need a family account? <Link to="/register">Register</Link>.</p>
        <p className="privacy-note">Demo uses synthetic identities only. No real patient data is stored.</p>
      </section>
    </main>
  )
}
