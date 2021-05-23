import React from 'react'
import ReactDOM from 'react-dom'
import { BrowserRouter, Route } from 'react-router-dom'
import ReactApp from '../src/ReactApp'

const reactPaths = [
  '/:lang?/races/:raceId/series/:seriesId/start_list',
  '/:lang?/races/:raceId',
]

document.addEventListener('DOMContentLoaded', () => {
  const appElement = document.getElementById('react-app')
  if (appElement) {
    const App = (
      <BrowserRouter>
        <Route path={reactPaths}>
          <ReactApp />
        </Route>
      </BrowserRouter>
    )
    ReactDOM.render(App, appElement)
  }
})
