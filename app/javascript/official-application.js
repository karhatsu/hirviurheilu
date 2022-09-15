import React from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import OfficialReactApp from './src/official/OfficialReactApp'

document.addEventListener('DOMContentLoaded', () => {
  const appElement = document.getElementById('official-react-app')
  if (appElement) {
    const App = (
      <BrowserRouter>
        <OfficialReactApp />
      </BrowserRouter>
    )
    const root = createRoot(appElement)
    root.render(App)
  }
})
