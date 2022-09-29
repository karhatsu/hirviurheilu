import React, { StrictMode, useCallback, useState } from 'react'
import { useParams } from 'react-router-dom'
import { RaceProvider } from '../util/useRace'
import { LayoutProvider } from '../util/useLayout'
import { MenuProvider } from '../util/useMenu'
import PageTitle from '../common/PageTitle'
import DesktopSecondLevelMenu from './menu/DesktopSecondLevelMenu'
import { ResultRotationProvider } from './result-rotation/useResultRotation'
import { CupProvider } from '../util/useCup'
import { HomePageProvider } from './home/useHomePage'
import DesktopSubMenu from './DesktopSubMenu'
import MainContent from './MainContent'
import Header from '../common/Header'
import MainMenu from '../common/MainMenu'
import Footer from '../common/Footer'
import useAppData from '../util/useAppData'
import { RacesPageProvider } from './races/useRacesPage'

const cupSeriesPaths = [
  '/:lang?/cups/:cupId/cup_series/:cupSeriesId',
  '/:lang?/cups/:cupId/rifle_cup_series/:rifleCupSeriesId',
]

function PublicReactApp() {
  const [mainMenuOpen, setMainMenuOpen] = useState(false)
  const { noNav } = useAppData()
  const { raceId } = useParams()
  const toggleMainMenu = useCallback(() => setMainMenuOpen(open => !open), [])
  const closeMainMenu = useCallback(() => setMainMenuOpen(false), [])
  return (
    <div>
      {!noNav && <Header toggleMainMenu={toggleMainMenu} />}
      {!noNav && <MainMenu closeMenu={closeMainMenu} mainMenuOpen={mainMenuOpen} />}
      <div className="body" itemScope itemType={raceId ? 'http://schema.org/SportsEvent' : ''}>
        <div className="body__on-top-title"><PageTitle /></div>
        <div className="body__content">
          {!noNav && <DesktopSecondLevelMenu />}
          {!noNav && <DesktopSubMenu cupSeriesPaths={cupSeriesPaths} />}
          <MainContent cupSeriesPaths={cupSeriesPaths} />
        </div>
      </div>
      {!noNav && <Footer />}
    </div>
  )
}

const PublicReactAppContainer = () => {
  return (
    <StrictMode>
      <LayoutProvider>
        <MenuProvider>
          <HomePageProvider>
            <RacesPageProvider>
              <RaceProvider>
                <CupProvider>
                  <ResultRotationProvider>
                    <PublicReactApp />
                  </ResultRotationProvider>
                </CupProvider>
              </RaceProvider>
            </RacesPageProvider>
          </HomePageProvider>
        </MenuProvider>
      </LayoutProvider>
    </StrictMode>
  )
}

export default PublicReactAppContainer
