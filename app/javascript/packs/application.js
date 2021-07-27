import React from 'react'
import ReactDOM from 'react-dom'
import { BrowserRouter, Route } from 'react-router-dom'
import ReactApp from '../src/ReactApp'

const reactPaths = [
  '/:lang?/races/:raceId/qualification_round_batches',
  '/:lang?/races/:raceId/final_round_batches',
  '/:lang?/races/:raceId/series/:seriesId/start_list',
  '/:lang?/races/:raceId/series/:seriesId',
  '/:lang?/races/:raceId/medium/new',
  '/:lang?/races/:raceId/rifle_team_competitions/:teamCompetitionId',
  '/:lang?/races/:raceId/team_competitions/:teamCompetitionId',
  '/:lang?/races/:raceId/relays/:relayId',
  '/:lang?/races/:raceId',
  '/:lang?/cups/:cupId/medium/new',
  '/:lang?/cups/:cupId/cup_series/:cupSeriesId',
  '/:lang?/cups/:cupId/rifle_cup_series/:rifleCupSeriesId',
  '/:lang?/cups/:cupId',
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
