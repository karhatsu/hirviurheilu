import React, { useCallback, useState } from 'react'
import { LayoutProvider } from '../util/useLayout'
import Footer from '../common/Footer'
import Header from '../common/Header'
import MainMenu from '../common/MainMenu'
import PageTitle from '../common/PageTitle'
import { RaceProvider } from '../util/useRace'
import DesktopRaceSecondLevelMenu from './menu/DesktopRaceSecondLevelMenu'
import OfficialMainContent from './OfficialMainContent'

const OfficialReactApp = () => {
  const [mainMenuOpen, setMainMenuOpen] = useState(false)
  const toggleMainMenu = useCallback(() => setMainMenuOpen(open => !open), [])
  const closeMainMenu = useCallback(() => setMainMenuOpen(false), [])
  return (
    <div>
      <Header toggleMainMenu={toggleMainMenu} />
      <MainMenu closeMenu={closeMainMenu} mainMenuOpen={mainMenuOpen} official={true} />
      <div className="body">
        <div className="body__on-top-title"><PageTitle /></div>
        <div className="body__content">
          <DesktopRaceSecondLevelMenu />
          <OfficialMainContent />
        </div>
      </div>
      <Footer />
    </div>
  )
}

const OfficialReactAppContainer = () => (
  <LayoutProvider>
    <RaceProvider>
      <OfficialReactApp />
    </RaceProvider>
  </LayoutProvider>
)

export default OfficialReactAppContainer
