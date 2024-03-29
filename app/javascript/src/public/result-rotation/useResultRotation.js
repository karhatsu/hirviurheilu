import React, { useCallback, useContext, useEffect, useState } from 'react'
import { useHistory, useParams } from 'react-router-dom'
import { buildSeriesResultsPath } from '../../util/routeUtil'
import { useRace } from '../../util/useRace'

const ResultRotationContext = React.createContext({})

export const useResultRotation = () => useContext(ResultRotationContext)

const minSeconds = 5

export const ResultRotationProvider = ({ children }) => {
  const history = useHistory()
  const { seriesId } = useParams()
  const [seconds, setSeconds] = useState(15)
  const [seriesIds, setSeriesIds] = useState([])
  const [started, setStarted] = useState(false)
  const [remainingSeconds, setRemainingSeconds] = useState(undefined)
  const { race } = useRace()

  const changeSeriesId = useCallback(id => event => {
    setSeriesIds(ids => {
      if (event.target.checked) {
        return [...ids, id]
      } else {
        const newIds = [...ids]
        const index = newIds.indexOf(id)
        newIds.splice(index, 1)
        return newIds
      }
    })
  }, [])

  const changeSeconds = useCallback(event => setSeconds(parseInt(event.target.value) || ''), [])

  const start = useCallback(() => {
    setStarted(true)
    history.push(buildSeriesResultsPath(race.id, seriesIds[0]))
  }, [race, seriesIds, history])

  const stop = useCallback(() => {
    setSeriesIds([])
    setStarted(false)
  }, [])

  useEffect(() => {
    let timeout, interval
    if (started && seriesId) {
      const index = seriesIds.indexOf(parseInt(seriesId))
      if (index !== -1) {
        const nextIndex = (index + 1) % seriesIds.length
        setRemainingSeconds(seconds)
        interval = setInterval(() => {
          setRemainingSeconds(secs => Math.max(0, secs - 1))
        }, 1000)
        timeout = setTimeout(() => {
          history.push(buildSeriesResultsPath(race.id, seriesIds[nextIndex]))
        }, seconds * 1000)
      } else {
        setRemainingSeconds(undefined)
      }
    }
    return () => {
      clearTimeout(timeout)
      clearInterval(interval)
    }
  }, [race?.id, started, seconds, seriesIds, seriesId, history])

  const value = {
    changeSeconds,
    changeSeriesId,
    seconds,
    minSeconds,
    seriesIds,
    start,
    started,
    stop,
    remainingSeconds,
  }
  return <ResultRotationContext.Provider value={value}>{children}</ResultRotationContext.Provider>
}
