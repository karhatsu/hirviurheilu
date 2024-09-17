import React from 'react'
import { Route, Routes } from 'react-router-dom'
import SeriesDesktopSubMenu from './menu/SeriesDesktopSubMenu'
import {
  buildNordicSeriesResultsPath,
  buildSeriesResultsPath,
  buildSeriesRifleResultsPath,
  buildSeriesShotgunsResultsPath,
  buildSeriesStartListPath,
} from '../util/routeUtil'
import TeamCompetitionDesktopSubMenu from './team-competition/TeamCompetitionDesktopSubMenu'
import RelayDesktopSubMenu from './relay/RelayDesktopSubMenu'
import CupDesktopSubMenu from './cup/CupDesktopSubMenu'
import CupTeamCompetitionsDesktopSubMenu from './cup/CupTeamCompetitionsDesktopSubMenu'
import { useRace } from '../util/useRace'
import { useCup } from '../util/useCup'
import { usePathParams } from './PathElementProvider'

export default function DesktopSubMenu() {
  const {
    relayId,
    seriesId,
    teamCompetitionId,
    cupSeriesId,
    cupTeamCompetitionId,
    rifleCupSeriesId,
  } = usePathParams()
  const { race } = useRace()
  const { cup } = useCup()
  return (
    <Routes>
      <Route path="races/:raceId/*">
        <Route
          path="series/:seriesId/start_list"
          element={<SeriesDesktopSubMenu
            race={race}
            currentSeriesId={seriesId}
            buildSeriesPath={buildSeriesStartListPath}
          />}
        />
        <Route
          path="series/:seriesId/rifle"
          element={<SeriesDesktopSubMenu
            race={race}
            currentSeriesId={seriesId}
            buildSeriesPath={buildSeriesRifleResultsPath}
          />}
        />
        <Route
          path="series/:seriesId/shotguns"
          element={<SeriesDesktopSubMenu
            race={race}
            currentSeriesId={seriesId}
            buildSeriesPath={buildSeriesShotgunsResultsPath}
          />}
        />
        <Route
          path="series/:seriesId/:subSport"
          element={<SeriesDesktopSubMenu
            race={race}
            currentSeriesId={seriesId}
            buildSeriesPath={buildNordicSeriesResultsPath}
          />}
        />
        <Route
          path="series/:seriesId"
          element={<SeriesDesktopSubMenu
            race={race}
            currentSeriesId={seriesId}
            buildSeriesPath={buildSeriesResultsPath}
          />}
        />
        <Route
          path="rifle_team_competitions/:teamCompetitionId"
          element={<TeamCompetitionDesktopSubMenu
            race={race}
            currentTeamCompetitionId={teamCompetitionId}
            rifle={true}
          />}
        />
        <Route
          path="team_competitions/:teamCompetitionId"
          element={<TeamCompetitionDesktopSubMenu race={race} currentTeamCompetitionId={teamCompetitionId} />}
        />
        <Route
          path="relays/:relaysId"
          element={<RelayDesktopSubMenu race={race} currentRelayId={relayId} />}
        />
      </Route>
      <Route path="cups/:cupId/*">
        <Route
          path="cup_series/:cupSeriesId"
          element={<CupDesktopSubMenu
            cup={cup}
            currentCupSeriesId={cupSeriesId}
            currentRifleCupSeriesId={rifleCupSeriesId}
          />}
        />
        <Route
          path="rifle_cup_series/:cupSeriesId"
          element={<CupDesktopSubMenu
            cup={cup}
            currentCupSeriesId={cupSeriesId}
            currentRifleCupSeriesId={rifleCupSeriesId}
          />}
        />
        <Route
          path="cup_team_competitions/:cupTeamCompetitionId"
          element={<CupTeamCompetitionsDesktopSubMenu
            cup={cup}
            currentCupTeamCompetitionId={cupTeamCompetitionId}
          />}
        />
      </Route>
    </Routes>
  )
}
