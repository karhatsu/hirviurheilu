import React from 'react'
import { Route, Switch, useParams } from 'react-router-dom'
import SeriesDesktopSubMenu from './public/menu/SeriesDesktopSubMenu'
import { buildSeriesResultsPath, buildSeriesRifleResultsPath, buildSeriesStartListPath } from './util/routeUtil'
import TeamCompetitionDesktopSubMenu from './public/team-competition/TeamCompetitionDesktopSubMenu'
import RelayDesktopSubMenu from './public/relay/RelayDesktopSubMenu'
import CupDesktopSubMenu from './public/cup/CupDesktopSubMenu'
import { useRace } from './util/useRace'
import { useCup } from './util/useCup'

export default function DesktopSubMenu({ cupSeriesPaths }) {
  const { relayId, seriesId, teamCompetitionId, cupSeriesId, rifleCupSeriesId } = useParams()
  const { race } = useRace()
  const { cup } = useCup()
  return (
    <Switch>
      <Route path="/:lang?/races/:raceId/series/:seriesId/start_list">
        <SeriesDesktopSubMenu race={race} currentSeriesId={seriesId} buildSeriesPath={buildSeriesStartListPath} />
      </Route>
      <Route path="/:lang?/races/:raceId/series/:seriesId/rifle">
        <SeriesDesktopSubMenu
          race={race}
          currentSeriesId={seriesId}
          buildSeriesPath={buildSeriesRifleResultsPath}
        />
      </Route>
      <Route path="/:lang?/races/:raceId/series/:seriesId">
        <SeriesDesktopSubMenu race={race} currentSeriesId={seriesId} buildSeriesPath={buildSeriesResultsPath} />
      </Route>
      <Route path="/:lang?/races/:raceId/rifle_team_competitions/:teamCompetitionId">
        <TeamCompetitionDesktopSubMenu race={race} currentTeamCompetitionId={teamCompetitionId} rifle={true} />
      </Route>
      <Route path="/:lang?/races/:raceId/team_competitions/:teamCompetitionId">
        <TeamCompetitionDesktopSubMenu race={race} currentTeamCompetitionId={teamCompetitionId} />
      </Route>
      <Route path="/:lang?/races/:raceId/relays/:relaysId">
        <RelayDesktopSubMenu race={race} currentRelayId={relayId} />
      </Route>
      <Route path={cupSeriesPaths}>
        <CupDesktopSubMenu cup={cup} currentCupSeriesId={cupSeriesId} currentRifleCupSeriesId={rifleCupSeriesId} />
      </Route>
    </Switch>
  )
}
