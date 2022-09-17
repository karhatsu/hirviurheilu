import React from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter, Route } from 'react-router-dom'
import OfficialReactApp from './src/official/OfficialReactApp'

const reactPaths = [
  '/:lang?/official/races/:raceId',
]

document.addEventListener('DOMContentLoaded', () => {
  const appElement = document.getElementById('official-react-app')
  if (appElement) {
    const App = (
      <BrowserRouter>
        <Route path={reactPaths}>
          <OfficialReactApp />
        </Route>
      </BrowserRouter>
    )
    const root = createRoot(appElement)
    root.render(App)
  }
})
