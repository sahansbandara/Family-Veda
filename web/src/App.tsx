import { BrowserRouter } from 'react-router-dom'

import { AmbientMesh } from './components/layout/AmbientMesh'
import { AppRoutes } from './routes/AppRouter'

function App() {
  return (
    <BrowserRouter>
      <AmbientMesh />
      <AppRoutes />
    </BrowserRouter>
  )
}

export default App
