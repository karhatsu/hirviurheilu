import { createRoot } from 'react-dom/client'
import { BrowserRouter, Route, Routes } from 'react-router'
import PublicReactApp from './src/public/PublicReactApp'

document.addEventListener('DOMContentLoaded', () => {
  const appElement = document.getElementById('public-react-app')
  if (appElement) {
    const App = (
      <BrowserRouter>
        <Routes>
          <Route path="/sv/*" element={<PublicReactApp />} />
          <Route path="*" element={<PublicReactApp />} />
        </Routes>
      </BrowserRouter>
    )
    const root = createRoot(appElement)
    root.render(App)
  }
})
