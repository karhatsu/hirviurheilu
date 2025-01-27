import React from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter, Route, Routes } from 'react-router'
import OfficialReactApp from './src/official/OfficialReactApp'

document.addEventListener('DOMContentLoaded', () => {
  const appElement = document.getElementById('official-react-app')
  if (appElement) {
    const App = (
      <BrowserRouter>
        <Routes>
          <Route path="/official/races/:raceId/*" element={<OfficialReactApp />} />
          <Route path="/:lang/official/races/:raceId/*" element={<OfficialReactApp />} />
        </Routes>
      </BrowserRouter>
    )
    const root = createRoot(appElement)
    root.render(App)
  }
})
