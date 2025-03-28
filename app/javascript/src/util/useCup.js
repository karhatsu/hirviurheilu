import { createContext, useCallback, useContext, useEffect, useState } from 'react'
import { usePathParams } from '../public/PathParamsProvider'
import { get } from './apiClient'

const CupContext = createContext({})

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
  return <CupContext value={value}>{children}</CupContext>
}
