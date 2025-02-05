import React, { useCallback, useState } from 'react'
import { LayoutProvider } from '../util/useLayout'
import Footer from '../common/Footer'
import Header from '../common/Header'
import MainMenu from '../common/MainMenu'
import PageTitle from '../common/PageTitle'
import { RaceProvider } from '../util/useRace'
import DesktopRaceSecondLevelMenu from './menu/DesktopRaceSecondLevelMenu'
import OfficialMainContent from './OfficialMainContent'
import { OfficialMenuProvider } from './menu/useOfficialMenu'
import { PathParamsContextProvider } from '../public/PathParamsProvider'
import { Route, Routes } from "react-router"

const OfficialReactApp = () => {
  const [mainMenuOpen, setMainMenuOpen] = useState(false)
  const toggleMainMenu = useCallback(() => setMainMenuOpen(open => !open), [])
  const closeMainMenu = useCallback(() => setMainMenuOpen(false), [])

  const [subMenuOpen, setSubMenuOpen] = useState(false)
  const toggleSubMenu = useCallback(e => {
    e.preventDefault()
    setSubMenuOpen(open => !open)
  }, [])

  return (
    <div>
      <Header toggleMainMenu={toggleMainMenu} />
      <MainMenu closeMenu={closeMainMenu} mainMenuOpen={mainMenuOpen} official={true} />
      <div className="body">
        <div className="body__on-top-title"><PageTitle /></div>
        <div className="body__content">
          <div className="menu-indicator">
            <a className="material-icons-outlined md-24" href="/" onClick={toggleSubMenu}>menu</a>
          </div>
          <Routes>
            <Route path="races/:raceId/*" element={<DesktopRaceSecondLevelMenu visible={subMenuOpen} />} />
          </Routes>
          <OfficialMainContent/>
        </div>
      </div>
      <Footer/>
    </div>
  )
}

const OfficialReactAppContainer = () => (
  <LayoutProvider>
    <PathParamsContextProvider>
      <RaceProvider>
        <OfficialMenuProvider>
          <OfficialReactApp />
        </OfficialMenuProvider>
      </RaceProvider>
    </PathParamsContextProvider>
  </LayoutProvider>
)

export default OfficialReactAppContainer
