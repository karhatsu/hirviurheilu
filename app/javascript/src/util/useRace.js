import React, { useCallback, useContext, useEffect, useRef, useState } from 'react'
import { useParams } from 'react-router-dom'
import { get } from './apiClient'
import useDataReloading from './useDataReloading'

const RaceContext = React.createContext({})

export const useRace = () => useContext(RaceContext)

export const RaceProvider = ({ children }) => {
  const { raceId } = useParams()
  const [race, setRace] = useState()
  const [error, setError] = useState()
  const fetchRaceRef = useRef()

  const fetchRace = useCallback(() => {
    get(`/api/v2/public/races/${raceId}?no_competitors=true`, (err, data) => {
      if (err) return setError(err)
      setRace(data)
    })
  }, [raceId])

  useEffect(() => {
    fetchRaceRef.current = () => {
      setRace(undefined)
      fetchRace()
    }
  }, [fetchRace])

  useEffect(() => {
    if (raceId) {
      fetchRaceRef.current()
    }
  }, [raceId])

  useDataReloading('RaceChannel', 'race_id', raceId, fetchRaceRef)

  const value = { fetching: !error && !race, race, error }
  return <RaceContext.Provider value={value}>{children}</RaceContext.Provider>
}
