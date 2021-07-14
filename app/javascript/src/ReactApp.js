import React, { useState } from 'react'
import { Route, Switch, useParams } from 'react-router-dom'
import { RaceProvider, useRace } from './util/useRace'
import { LayoutProvider } from './util/useLayout'
import PageTitle from './PageTitle'
import DesktopSecondLevelMenu from './public/menu/DesktopSecondLevelMenu'
import SeriesDesktopSubMenu from './public/menu/SeriesDesktopSubMenu'
import FacebookShare from './public/FacebookShare'
import StartListPage from './public/start-list/StartListPage'
import { buildSeriesResultsPath, buildSeriesRifleResultsPath, buildSeriesStartListPath } from './util/routeUtil'
import RacePage from './public/race-page/RacePage'
import SeriesResultsPage from './public/series-results/SeriesResultsPage'
import NordicSubSportResultsPage from './public/nordic/NordicSubSportResultsPage'
import EuropeanRifleResultsPage from './public/european/EuropeanRifleResultsPage'
import TeamCompetitionResultsPage from './public/team-competition/TeamCompetitionResultsPage'
import TeamCompetitionDesktopSubMenu from './public/team-competition/TeamCompetitionDesktopSubMenu'
import RelayDesktopSubMenu from './public/relay/RelayDesktopSubMenu'
import RelayResultsPage from './public/relay/RelayResultsPage'
import RaceMediaPage from './public/media/RaceMediaPage'
import QualificationRoundBatches from './public/batches/QualificationRoundBatches'
import FinalRoundBatches from './public/batches/FinalRoundBatches'

function ReactApp() {
  const [selectedPage, setSelectedPage] = useState(undefined)
  const { raceId, relayId, seriesId, teamCompetitionId } = useParams()
  const { race } = useRace()
  return (
    <div className="body" itemScope itemType={raceId ? 'http://schema.org/SportsEvent' : ''}>
      <div className="body__on-top-title"><PageTitle /></div>
      <div className="body__content">
        <DesktopSecondLevelMenu selectedPage={selectedPage} />
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
        </Switch>
        <div className="body__yield">
          <div className="body__under-top-title"><PageTitle /></div>
          <FacebookShare />
          <Switch exact>
            <Route
              path="/:lang?/races/:raceId/rifle_team_competitions/:teamCompetitionId"
              render={() => <TeamCompetitionResultsPage setSelectedPage={setSelectedPage} rifle={true} />}
            />
            <Route
              path="/:lang?/races/:raceId/team_competitions/:teamCompetitionId"
              render={() => <TeamCompetitionResultsPage setSelectedPage={setSelectedPage} />}
            />
            <Route
              path="/:lang?/races/:raceId/qualification_round_batches"
              render={() => <QualificationRoundBatches setSelectedPage={setSelectedPage} />}
            />
            <Route
              path="/:lang?/races/:raceId/final_round_batches"
              render={() => <FinalRoundBatches setSelectedPage={setSelectedPage} />}
            />
            <Route
              path="/:lang?/races/:raceId/series/:seriesId/start_list"
              render={() => <StartListPage setSelectedPage={setSelectedPage} />}
            />
            <Route
              path="/:lang?/races/:raceId/series/:seriesId/rifle"
              render={() => <EuropeanRifleResultsPage setSelectedPage={setSelectedPage} />}
            />
            <Route
              path="/:lang?/races/:raceId/series/:seriesId"
              render={() => <SeriesResultsPage setSelectedPage={setSelectedPage} />}
            />
            <Route
              path={['/:lang?/races/:raceId/relays/:relayId/legs/:leg', '/:lang?/races/:raceId/relays/:relayId']}
              render={() => <RelayResultsPage setSelectedPage={setSelectedPage} />}
            />
            <Route
              path="/:lang?/races/:raceId/medium/new"
              render={() => <RaceMediaPage setSelectedPage={setSelectedPage} />}
            />
            <Route
              path="/:lang?/races/:raceId/:subSport"
              render={() => <NordicSubSportResultsPage setSelectedPage={setSelectedPage} />}
            />
            <Route path="/:lang?/races/:raceId" render={() => <RacePage setSelectedPage={setSelectedPage} />} />
          </Switch>
        </div>
      </div>
    </div>
  )
}

const ReactAppContainer = () => {
  return (
    <LayoutProvider>
      <RaceProvider>
        <ReactApp />
      </RaceProvider>
    </LayoutProvider>
  )
}

export default ReactAppContainer
