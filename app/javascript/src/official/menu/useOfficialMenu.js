import React, { useContext, useState } from 'react'

const OfficialMenuContext = React.createContext({})

const useOfficialMenu = () => {
  const { selectedPage, setSelectedPage } = useContext(OfficialMenuContext)
  return { selectedPage, setSelectedPage }
}

export const OfficialMenuProvider = ({ children }) => {
  const [selectedPage, setSelectedPage] = useState(undefined)
  const value = { selectedPage, setSelectedPage }
  return <OfficialMenuContext value={value}>{children}</OfficialMenuContext>
}

export default useOfficialMenu
