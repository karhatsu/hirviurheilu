import { useCallback, useEffect, useState } from 'react'

const sortMethods = { points: 0, time: 1, estimates: 2, shooting: 3 }

const compareNoResultReason = (a, b) => (a.noResultReason || '').localeCompare((b.noResultReason || ''))

const noTime = 9999999

const useCompetitorSorting = (series, setAllCompetitors) => {
  const [competitors, setCompetitors] = useState(series.competitors)
  const [sortMethod, setSortMethod] = useState(sortMethods.points)

  useEffect(() => {
    setCompetitors(series.competitors)
  }, [series.competitors])

  const sortByTime = useCallback(() => {
    return competitors.sort((a, b) => {
      const noResultReason = compareNoResultReason(a, b)
      if (noResultReason) return noResultReason
      return (a.timeInSeconds || noTime) - (b.timeInSeconds || noTime)
    })
  }, [competitors])

  const sortByEstimates = useCallback(() => {
    return competitors.sort((a, b) => {
      const noResultReason = compareNoResultReason(a, b)
      if (noResultReason) return noResultReason
      return b.estimatePoints - a.estimatePoints
    })
  }, [competitors])

  const sortByShooting = useCallback(() => {
    return competitors.sort((a, b) => {
      const noResultReason = compareNoResultReason(a, b)
      if (noResultReason) return noResultReason
      return b.shootingPoints - a.shootingPoints
    })
  }, [competitors])

  const sortByPoints = useCallback(() => {
    return competitors.sort((a, b) => {
      return a.position - b.position
    })
  }, [competitors])

  const sort = useCallback(bySortMethod => {
    setSortMethod(bySortMethod)
    setAllCompetitors(false)
    if (bySortMethod === sortMethods.time) setCompetitors(sortByTime())
    if (bySortMethod === sortMethods.estimates) setCompetitors(sortByEstimates())
    if (bySortMethod === sortMethods.shooting) setCompetitors(sortByShooting())
    if (bySortMethod === sortMethods.points) setCompetitors(sortByPoints())
  }, [setAllCompetitors, sortByTime, sortByEstimates, sortByShooting, sortByPoints])
  return { competitors, sortMethod, sortMethods, sort }
}

export default useCompetitorSorting
