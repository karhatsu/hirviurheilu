import React, { useState } from 'react'
import { Route, Switch, useParams } from 'react-router-dom'
import { RaceProvider, useRace } from './util/useRace'
import { LayoutProvider } from './util/useLayout'
import PageTitle from './PageTitle'
import DesktopSecondLevelMenu from './public/menu/DesktopSecondLevelMenu'
import SeriesDesktopSubMenu from './public/menu/SeriesDesktopSubMenu'
import FacebookShare from './public/FacebookShare'
import StartListPage from './public/start-list/StartListPage'
import { buildSeriesResultsPath, buildSeriesStartListPath } from './util/routeUtil'
import RacePage from './public/race-page/RacePage'
import SeriesResultsPage from './public/series-results/SeriesResultsPage'
import NordicSubSportResultsPage from './public/nordic/NordicSubSportResultsPage'

function ReactApp() {
  const [selectedPage, setSelectedPage] = useState(undefined)
  const { raceId, seriesId } = useParams()
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
          <Route path="/:lang?/races/:raceId/series/:seriesId">
            <SeriesDesktopSubMenu race={race} currentSeriesId={seriesId} buildSeriesPath={buildSeriesResultsPath} />
          </Route>
        </Switch>
        <div className="body__yield">
          <div className="body__under-top-title"><PageTitle /></div>
          <FacebookShare />
          <Switch exact>
            <Route
              path="/:lang?/races/:raceId/series/:seriesId/start_list"
              render={() => <StartListPage setSelectedPage={setSelectedPage} />}
            />
            <Route
              path="/:lang?/races/:raceId/series/:seriesId"
              render={() => <SeriesResultsPage setSelectedPage={setSelectedPage} />}
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
