import React from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter, Route } from 'react-router-dom'
import PublicReactApp from './src/public/PublicReactApp'

const reactPaths = [
  '/:lang?/races/:raceId/qualification_round_heats',
  '/:lang?/races/:raceId/final_round_heats',
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
  '/:lang?/cups/:cupId/cup_team_competitions/:cupTeamCompetitionId',
  '/:lang?/cups/:cupId',
  '/:lang?/announcements/:announcementId',
  '/:lang?',
]

document.addEventListener('DOMContentLoaded', () => {
  const appElement = document.getElementById('public-react-app')
  if (appElement) {
    const App = (
      <BrowserRouter>
        <Route path={reactPaths}>
          <PublicReactApp />
        </Route>
      </BrowserRouter>
    )
    const root = createRoot(appElement)
    root.render(App)
  }
})
