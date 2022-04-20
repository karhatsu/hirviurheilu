import React, { createContext, useCallback, useContext, useState } from 'react'
import { buildQueryParams, get } from '../../util/apiClient'

const HomePageContext = createContext({})

const useHomePage = () => useContext(HomePageContext)

export const HomePageProvider = ({ children }) => {
  const [error, setError] = useState()
  const [data, setData] = useState()
  const [searchParams, setSearchParams] = useState({})
  const [searching, setSearching] = useState(false)

  const setSearchValue = useCallback(key => value => {
    setSearching(true)
    setSearchParams(params => {
      return { ...params, [key]: value }
    })
  }, [])

  const search = useCallback(() => {
    const path = `/api/v2/public/home?${buildQueryParams(searchParams)}`
    get(path, (err, data) => {
      if (err) setError(err)
      else setData(data)
      setSearching(false)
    })
  }, [searchParams])

  const value = {
    data,
    error,
    searchParams,
    setSearchValue,
    search,
    searching,
  }
  return <HomePageContext.Provider value={value}>{children}</HomePageContext.Provider>
}

export default useHomePage
