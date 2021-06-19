import React, { useContext, useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import { get } from './apiClient'

const RaceContext = React.createContext({})

export const useRace = () => useContext(RaceContext)

export const RaceProvider = ({ children }) => {
  const { raceId } = useParams()
  const [race, setRace] = useState()
  const [error, setError] = useState()

  useEffect(() => {
    if (raceId) {
      get(`/api/v2/public/races/${raceId}?no_competitors=true`, (err, data) => {
        if (err) return setError(err)
        setRace(data)
      })
    }
  }, [raceId])

  const value = { fetching: !error && !race, race, error }
  return <RaceContext.Provider value={value}>{children}</RaceContext.Provider>
}
