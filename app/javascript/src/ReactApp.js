import React from 'react'
import { Route, Switch, useParams } from 'react-router-dom'
import { RaceProvider, useRace } from './util/useRace'
import PageTitle from './PageTitle'
import DesktopSecondLevelMenu from './public/menu/DesktopSecondLevelMenu'
import SeriesDesktopSubMenu from './public/menu/SeriesDesktopSubMenu'
import FacebookShare from './public/FacebookShare'
import StartListPage from './public/start-list/StartListPage'
import { buildSeriesStartListPath } from './util/routeUtil'
import RacePage from './race-page/RacePage'

function ReactApp() {
  const { raceId, seriesId } = useParams()
  const { race } = useRace()
  return (
    <div className="body" itemScope itemType={raceId ? 'http://schema.org/SportsEvent' : ''}>
      <div className="body__on-top-title"><PageTitle /></div>
      <div className="body__content">
        <DesktopSecondLevelMenu />
        <Route path="/:lang?/races/:raceId/series/:seriesId/start_list">
          <SeriesDesktopSubMenu race={race} currentSeriesId={seriesId} buildSeriesLink={buildSeriesStartListPath} />
        </Route>
        <div className="body__yield">
          <div className="body__under-top-title"><PageTitle /></div>
          <FacebookShare />
          <Switch exact>
            <Route path="/:lang?/races/:raceId/series/:seriesId/start_list" component={StartListPage} />
            <Route path="/:lang?/races/:raceId" component={RacePage} />
          </Switch>
        </div>
      </div>
    </div>
  )
}

const ReactAppContainer = () => {
  return (
    <RaceProvider>
      <ReactApp />
    </RaceProvider>
  )
}

export default ReactAppContainer
