import { createContext, useCallback, useContext, useEffect, useState } from 'react'
import { useNavigate } from 'react-router'
import { buildSeriesResultsPath, buildTeamCompetitionsPath } from '../../util/routeUtil'
import { useRace } from '../../util/useRace'
import { usePathParams } from '../PathParamsProvider'

const ResultRotationContext = createContext({})

export const useResultRotation = () => useContext(ResultRotationContext)

const minSeconds = 5

export const ResultRotationProvider = ({ children }) => {
  const navigate = useNavigate()
  const { seriesId, teamCompetitionId } = usePathParams()
  const [seconds, setSeconds] = useState(15)
  const [seriesIds, setSeriesIds] = useState([])
  const [teamCompetitionIds, setTeamCompetitionIds] = useState([])
  const [started, setStarted] = useState(false)
  const [remainingSeconds, setRemainingSeconds] = useState(undefined)
  const { race } = useRace()

  const changeId = useCallback((setter, id) => event => {
    setter(ids => {
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

  const changeSeriesId = useCallback(id => changeId(setSeriesIds, id), [changeId])
  const changeTeamCompetitionId = useCallback(id => changeId(setTeamCompetitionIds, id), [changeId])

  const changeSeconds = useCallback(event => setSeconds(parseInt(event.target.value) || ''), [])

  const start = useCallback(() => {
    setStarted(true)
    const path = seriesIds.length
      ? buildSeriesResultsPath(race.id, seriesIds[0])
      : buildTeamCompetitionsPath(race.id, teamCompetitionIds[0])
    navigate(path)
  }, [race, seriesIds, teamCompetitionIds, navigate])

  const stop = useCallback(() => {
    setSeriesIds([])
    setTeamCompetitionIds([])
    setStarted(false)
  }, [])

  const resolveNextPath = useCallback(() => {
    const seriesIndex = seriesId ? seriesIds.indexOf(parseInt(seriesId)) : -1
    const tcIndex = teamCompetitionId ? teamCompetitionIds.indexOf(parseInt(teamCompetitionId)) : -1
    if (seriesIndex !== -1 && seriesIndex === seriesIds.length - 1 && teamCompetitionIds.length) {
      return buildTeamCompetitionsPath(race.id, teamCompetitionIds[0])
    } else if (tcIndex !== -1 && tcIndex === teamCompetitionIds.length - 1 && seriesIds.length) {
      return buildSeriesResultsPath(race.id, seriesIds[0])
    } else if (seriesIndex !== -1) {
      const nextIndex = (seriesIndex + 1) % seriesIds.length
      return buildSeriesResultsPath(race.id, seriesIds[nextIndex])
    } else if (tcIndex !== -1) {
      const nextIndex = (tcIndex + 1) % teamCompetitionIds.length
      return buildTeamCompetitionsPath(race.id, teamCompetitionIds[nextIndex])
    }
  }, [race?.id, seriesIds, seriesId, teamCompetitionIds, teamCompetitionId])

  useEffect(() => {
    let timeout, interval
    if (started) {
      const nextPath = resolveNextPath()
      if (nextPath) {
        setRemainingSeconds(seconds)
        interval = setInterval(() => {
          setRemainingSeconds(secs => Math.max(0, secs - 1))
        }, 1000)
        timeout = setTimeout(() => {
          navigate(nextPath)
        }, seconds * 1000)
      } else {
        setRemainingSeconds(undefined)
      }
    }
    return () => {
      clearTimeout(timeout)
      clearInterval(interval)
    }
  }, [resolveNextPath, started, seconds, navigate])

  const value = {
    changeSeconds,
    changeSeriesId,
    changeTeamCompetitionId,
    seconds,
    minSeconds,
    seriesIds,
    start,
    started,
    stop,
    remainingSeconds,
    teamCompetitionIds,
  }
  return <ResultRotationContext value={value}>{children}</ResultRotationContext>
}
