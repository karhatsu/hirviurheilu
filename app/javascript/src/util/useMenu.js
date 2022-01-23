import React, { useContext, useState } from 'react'

const MenuContext = React.createContext({})

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
  media: 11,
  batches: {
    qualificationRound: 12,
    finalRound: 13,
  },
  resultRotation: 14,
  cup: {
    home: 15,
    results: 16,
    rifleResults: 17,
    media: 18,
  },
  info: {
    main: 19,
    prices: 20,
    answers: 21,
    feedback: 22,
    sportsInfo: 23,
  },
}

const useMenu = () => {
  const { selectedPage, setSelectedPage } = useContext(MenuContext)
  return { selectedPage, setSelectedPage }
}

export const MenuProvider = ({ children }) => {
  const [selectedPage, setSelectedPage] = useState(undefined)
  const value = { selectedPage, setSelectedPage }
  return <MenuContext.Provider value={value}>{children}</MenuContext.Provider>
}

export default useMenu
