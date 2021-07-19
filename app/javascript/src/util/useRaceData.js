import { useCallback, useEffect, useRef, useState } from 'react'
import { useRace } from './useRace'
import { get } from './apiClient'

const useRaceData = buildApiPath => {
  const [fetching, setFetching] = useState(true)
  const [error, setError] = useState()
  const [raceData, setRaceData] = useState()
  const reloadDataRef = useRef()
  const { race } = useRace()

  const reloadData = useCallback(() => {
    get(buildApiPath(race.id), (err, data) => {
      if (err) {
        setError(err)
      } else {
        setError(undefined)
        setRaceData(data)
      }
      setFetching(false)
    })
  }, [race, buildApiPath])

  useEffect(() => {
    reloadDataRef.current = reloadData
  }, [reloadData])

  useEffect(() => {
    setFetching(true) // either race was reloaded or e.g. series (buildApiPath) changed
    if (race) {
      reloadData()
    }
  }, [race, reloadData])

  return {
    error,
    fetching: fetching || !race,
    race,
    raceData,
    reloadDataRef,
  }
}

export default useRaceData
