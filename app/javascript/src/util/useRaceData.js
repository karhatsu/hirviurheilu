import { useEffect, useState } from 'react'
import { useRace } from './useRace'
import { get } from './apiClient'

const useRaceData = buildApiPath => {
  const [fetching, setFetching] = useState(true)
  const [error, setError] = useState()
  const [raceData, setRaceData] = useState()
  const { race } = useRace()

  useEffect(() => {
    if (race) {
      setFetching(true)
      get(buildApiPath(race.id), (err, data) => {
        if (err) {
          setError(err)
        } else {
          setError(undefined)
          setRaceData(data)
        }
        setFetching(false)
      })
    }
  }, [race, buildApiPath])

  return {
    error,
    fetching,
    race,
    raceData,
  }
}

export default useRaceData
