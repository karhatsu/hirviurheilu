import { createContext, useContext, useState } from 'react'

const MenuContext = createContext({})

export const pages = {
  raceHome: 0,
  results: 1,
  startList: 2,
  nordic: {
    trap: 3,
    shotgun: 4,
    rifle_standing: 5,
    rifle_moving: 6,
  },
  europeanRifle: 7,
  teamCompetitions: 8,
  rifleTeamCompetitions: 9,
  relays: 10,
  press: 11,
  heats: {
    qualificationRound: 12,
    finalRound: 13,
  },
  resultRotation: 14,
  cup: {
    home: 15,
    results: 16,
    rifleResults: 17,
    teamCompetitions: 24,
    press: 18,
  },
  info: {
    main: 19,
    prices: 20,
    answers: 21,
    feedback: 22,
    sportsInfo: 23,
  },
  europeanShotgun: 24,
  events: {
    main: 25,
    competitors: 26,
    syncNumbers: 27,
    prints: 29,
  },
}

const useMenu = () => {
  const { selectedPage, setSelectedPage } = useContext(MenuContext)
  return { selectedPage, setSelectedPage }
}

export const MenuProvider = ({ children }) => {
  const [selectedPage, setSelectedPage] = useState(undefined)
  const value = { selectedPage, setSelectedPage }
  return <MenuContext value={value}>{children}</MenuContext>
}

export default useMenu
