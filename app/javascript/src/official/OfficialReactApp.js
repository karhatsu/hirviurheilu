import React, { useCallback, useState } from 'react'
import { LayoutProvider } from '../util/useLayout'
import Footer from '../common/Footer'
import Header from '../common/Header'
import MainMenu from '../common/MainMenu'
import PageTitle from '../common/PageTitle'
import { RaceProvider } from '../util/useRace'
import RaceSecondLevelMenu from './menu/RaceSecondLevelMenu'
import OfficialMainContent from './OfficialMainContent'
import { OfficialMenuProvider } from './menu/useOfficialMenu'
import { PathParamsContextProvider } from '../public/PathParamsProvider'
import { Route, Routes } from "react-router"
import { EventProvider } from "../util/useEvent"
import EventSecondLevelMenu from "./menu/EventSecondLevelMenu"

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
            <Route path="events/:eventId/*" element={<EventSecondLevelMenu visible={subMenuOpen} />} />
            <Route path="races/:raceId/*" element={<RaceSecondLevelMenu visible={subMenuOpen} />} />
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
        <EventProvider>
          <OfficialMenuProvider>
            <OfficialReactApp />
          </OfficialMenuProvider>
        </EventProvider>
      </RaceProvider>
    </PathParamsContextProvider>
  </LayoutProvider>
)

export default OfficialReactAppContainer
