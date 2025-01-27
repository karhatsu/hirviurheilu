import React from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import PublicReactApp from './src/public/PublicReactApp'

document.addEventListener('DOMContentLoaded', () => {
  const appElement = document.getElementById('public-react-app')
  if (appElement) {
    const App = (
      <BrowserRouter future={{ v7_relativeSplatPath: true, v7_startTransition: true }}>
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
