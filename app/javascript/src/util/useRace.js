import { createContext, useCallback, useContext, useEffect, useRef, useState } from 'react'
import { usePathParams } from '../public/PathParamsProvider'
import { get } from './apiClient'
import useDataReloading from './useDataReloading'

const RaceContext = createContext({})

export const useRace = () => useContext(RaceContext)

export const RaceProvider = ({ children }) => {
  const { raceId } = usePathParams()
  const [race, setRace] = useState()
  const [error, setError] = useState()
  const fetchRaceRef = useRef(undefined)

  const fetchRace = useCallback(() => {
    get(`/api/v2/official/races/${raceId}?no_competitors=true`, (err, data) => {
      if (err) return setError(err)
      setRace(data)
    })
  }, [raceId])

  useEffect(() => {
    fetchRaceRef.current = (reload) => {
      if (!reload) setRace(undefined)
      fetchRace()
    }
  }, [fetchRace])

  useEffect(() => {
    if (raceId) {
      fetchRaceRef.current()
    }
  }, [raceId])

  const reload = useCallback(() => {
    fetchRaceRef.current(true)
  }, [])

  useDataReloading('RaceChannel', 'race_id', raceId, fetchRaceRef)

  const value = { fetching: !error && !race, race, error, reload }
  return <RaceContext value={value}>{children}</RaceContext>
}
