import React, { useCallback, useState } from 'react'
import { useParams } from 'react-router-dom'
import { RaceProvider } from './util/useRace'
import { LayoutProvider } from './util/useLayout'
import { MenuProvider } from './util/useMenu'
import PageTitle from './PageTitle'
import DesktopSecondLevelMenu from './public/menu/DesktopSecondLevelMenu'
import { ResultRotationProvider } from './public/result-rotation/useResultRotation'
import { CupProvider } from './util/useCup'
import DesktopSubMenu from './DesktopSubMenu'
import MainContent from './MainContent'
import Header from './Header'
import MainMenu from './MainMenu'
import Footer from './Footer'

const cupSeriesPaths = [
  '/:lang?/cups/:cupId/cup_series/:cupSeriesId',
  '/:lang?/cups/:cupId/rifle_cup_series/:rifleCupSeriesId',
]

function ReactApp() {
  const [mainMenuOpen, setMainMenuOpen] = useState(false)
  const { raceId } = useParams()
  const toggleMainMenu = useCallback(() => setMainMenuOpen(open => !open), [])
  const closeMainMenu = useCallback(() => setMainMenuOpen(false), [])
  return (
    <div>
      <Header toggleMainMenu={toggleMainMenu} />
      <MainMenu closeMenu={closeMainMenu} mainMenuOpen={mainMenuOpen} />
      <div className="body" itemScope itemType={raceId ? 'http://schema.org/SportsEvent' : ''}>
        <div className="body__on-top-title"><PageTitle /></div>
        <div className="body__content">
          <DesktopSecondLevelMenu />
          <DesktopSubMenu cupSeriesPaths={cupSeriesPaths} />
          <MainContent cupSeriesPaths={cupSeriesPaths} />
        </div>
      </div>
      <Footer />
    </div>
  )
}

const ReactAppContainer = () => {
  return (
    <LayoutProvider>
      <MenuProvider>
        <RaceProvider>
          <CupProvider>
            <ResultRotationProvider>
              <ReactApp />
            </ResultRotationProvider>
          </CupProvider>
        </RaceProvider>
      </MenuProvider>
    </LayoutProvider>
  )
}

export default ReactAppContainer
