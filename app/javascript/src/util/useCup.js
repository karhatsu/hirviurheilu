import React, { useCallback, useContext, useEffect, useState } from 'react'
import { usePathParams } from '../public/PathElementProvider'
import { get } from './apiClient'

const CupContext = React.createContext({})

export const useCup = () => useContext(CupContext)

export const CupProvider = ({ children }) => {
  const { cupId } = usePathParams()
  const [cup, setCup] = useState()
  const [error, setError] = useState()

  const fetchCup = useCallback(() => {
    get(`/api/v2/public/cups/${cupId}`, (err, data) => {
      if (err) return setError(err)
      setCup(data)
    })
  }, [cupId])

  useEffect(() => {
    if (cupId) {
      fetchCup()
    }
  }, [cupId, fetchCup])

  const value = { fetching: !error && !cup, cup, error }
  return <CupContext.Provider value={value}>{children}</CupContext.Provider>
}
