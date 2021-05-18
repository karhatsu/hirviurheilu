import React from 'react'
import { Route, useParams } from 'react-router-dom'
import { RaceProvider, useRace } from './util/useRace'
import PageTitle from './PageTitle'
import DesktopSecondLevelMenu from './public/DesktopSecondLevelMenu'
import SeriesDesktopSubMenu from './public/SeriesDesktopSubMenu'
import FacebookShare from './public/FacebookShare'
import StartList from './public/StartList'
import { buildSeriesStartListLink } from './util/routeUtil'

function App() {
  const { raceId, seriesId } = useParams()
  const { race } = useRace()
  return (
    <div className="body" itemScope itemType={raceId ? 'http://schema.org/SportsEvent' : ''}>
      <div className="body__on-top-title"><PageTitle /></div>
      <div className="body__content">
        <DesktopSecondLevelMenu />
        <Route path="/:lang?/races/:raceId/series/:seriesId/start_list">
          <SeriesDesktopSubMenu race={race} currentSeriesId={seriesId} buildSeriesLink={buildSeriesStartListLink} />
        </Route>
        <div className="body__yield">
          <div className="body__under-top-title"><PageTitle /></div>
          <FacebookShare />
          <Route path="/:lang?/races/:raceId/series/:seriesId/start_list" component={StartList} />
        </div>
      </div>
    </div>
  )
}

const AppContainer = () => {
  return (
    <RaceProvider>
      <App />
    </RaceProvider>
  )
}

export default AppContainer
