import { createContext, useCallback, useContext, useEffect, useMemo, useRef, useState } from 'react'
import { usePathParams } from '../public/PathParamsProvider'
import { get } from './apiClient'
import useDataReloading from './useDataReloading'
import { useLocation } from 'react-router'

const RaceContext = createContext({})

export const useRace = () => useContext(RaceContext)

export const RaceProvider = ({ children, official }) => {
  const { raceId } = usePathParams()
  const location = useLocation()
  const [race, setRace] = useState()
  const [error, setError] = useState()
  const fetchRaceRef = useRef(undefined)

  const racePath = useMemo(() => {
    if (location.pathname.startsWith('/official/limited')) return `/official/limited/races/${raceId}.json`
    if (official) return `/official/races/${raceId}.json`
    return `/api/v2/public/races/${raceId}?no_competitors=true`
  }, [location, official, raceId])

  const fetchRace = useCallback(() => {
    get(racePath, (err, data) => {
      if (err) return setError(err)
      setRace(data)
    })
  }, [racePath])

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

  const value = { fetching: !error && !race, race, error, reload, setRace }
  return <RaceContext value={value}>{children}</RaceContext>
}
