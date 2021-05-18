import React from 'react'
import ReactDOM from 'react-dom'
import { BrowserRouter, Route } from 'react-router-dom'
import App from '../src/app'

const reactPaths = [
  '/:lang?/races/:raceId/series/:seriesId/start_list',
]

document.addEventListener('DOMContentLoaded', () => {
  const appElement = document.getElementById('react-app')
  if (appElement) {
    const ReactApp = (
      <BrowserRouter>
        <Route path={reactPaths}>
          <App />
        </Route>
      </BrowserRouter>
    )
    ReactDOM.render(ReactApp, appElement)
  }
})
