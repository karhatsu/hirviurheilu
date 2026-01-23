import { useCallback, useEffect, useRef, useState } from 'react'

const sortMethods = { points: 0, time: 1, estimates: 2, shooting: 3 }

const compareNoResultReason = (a, b) => (a.noResultReason || '').localeCompare(b.noResultReason || '')

const noTime = 9999999

const sortByTime = (competitors) =>
  [...competitors].sort((a, b) => {
    const noResultReason = compareNoResultReason(a, b)
    if (noResultReason) return noResultReason
    return (a.timeInSeconds || noTime) - (b.timeInSeconds || noTime)
  })

const sortByEstimates = (competitors) =>
  [...competitors].sort((a, b) => {
    const noResultReason = compareNoResultReason(a, b)
    if (noResultReason) return noResultReason
    return b.estimatePoints - a.estimatePoints
  })

const sortByShooting = (competitors) =>
  [...competitors].sort((a, b) => {
    const noResultReason = compareNoResultReason(a, b)
    if (noResultReason) return noResultReason
    return b.shootingPoints - a.shootingPoints
  })

const sortByPoints = (competitors) =>
  [...competitors].sort((a, b) => {
    return a.position - b.position
  })

const useCompetitorSorting = (series) => {
  const [competitors, setCompetitors] = useState(series.competitors)
  const [sortMethod, setSortMethod] = useState(sortMethods.points)
  const competitorsRef = useRef(competitors)

  const sort = useCallback(
    (bySortMethod) => {
      if (bySortMethod === sortMethods.time) setCompetitors(sortByTime(competitorsRef.current))
      if (bySortMethod === sortMethods.estimates) setCompetitors(sortByEstimates(competitorsRef.current))
      if (bySortMethod === sortMethods.shooting) setCompetitors(sortByShooting(competitorsRef.current))
      if (bySortMethod === sortMethods.points) setCompetitors(sortByPoints(competitorsRef.current))
    },
    [competitorsRef],
  )

  useEffect(() => {
    competitorsRef.current = competitors
  }, [competitors])

  useEffect(() => {
    competitorsRef.current = series.competitors
    setCompetitors(series.competitors) // eslint-disable-line react-hooks/set-state-in-effect
    sort(sortMethod)
  }, [series.competitors, sort, sortMethod])

  return { competitors, setSortMethod, sortMethod, sortMethods }
}

export default useCompetitorSorting
