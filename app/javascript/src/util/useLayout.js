import React, { useCallback, useContext, useEffect, useState } from 'react'

const LayoutContext = React.createContext({})

const useLayout = () => useContext(LayoutContext)

export const LayoutProvider = ({ children }) => {
  const [mobile, setMobile] = useState(true)

  const resizeListener = useCallback(() => {
    setMobile(window.innerWidth < 768)
  }, [])

  useEffect(() => {
    resizeListener()
    window.addEventListener('resize', resizeListener)
    window.forceMobileLayout = setMobile
    return () => {
      window.removeEventListener('resize', resizeListener)
    }
  }, [resizeListener])

  const value = { mobile }
  return <LayoutContext.Provider value={value}>{children}</LayoutContext.Provider>
}

export default useLayout
