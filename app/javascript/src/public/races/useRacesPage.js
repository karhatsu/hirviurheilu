import React, { createContext, useCallback, useContext, useState } from 'react'
import { buildQueryParams, get } from '../../util/apiClient'

const RacesPageContext = createContext({})

const useRacesPage = () => useContext(RacesPageContext)

export const RacesPageProvider = ({ children }) => {
  const [fetching, setFetching] = useState(true)
  const [data, setData] = useState(undefined)
  const [error, setError] = useState(undefined)

  const search = useCallback(searchParams => {
    setFetching(true)
    const query = { ...searchParams, grouped: true }
    const path = `/api/v2/public/races?${buildQueryParams(query)}`
    get(path, (err, data) => {
      if (err) setError(err)
      else setData(data)
      setFetching(false)
    })
  }, [])

  const value = { data, error, fetching, search }

  return <RacesPageContext.Provider value={value}>{children}</RacesPageContext.Provider>
}

export default useRacesPage
