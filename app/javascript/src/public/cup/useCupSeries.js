import { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import { get } from '../../util/apiClient'

const useCupSeries = () => {
  const [fetching, setFetching] = useState(true)
  const { cupId, cupSeriesId, rifleCupSeriesId } = useParams()
  const [cupSeries, setCupSeries] = useState()
  const [error, setError] = useState()

  useEffect(() => {
    setFetching(true)
    const path = rifleCupSeriesId ? 'rifle_cup_series' : 'cup_series'
    const seriesId = rifleCupSeriesId || cupSeriesId
    get(`/api/v2/public/cups/${cupId}/${path}/${seriesId}`, (err, data) => {
      if (err) return setError(err)
      setCupSeries(data)
      setFetching(false)
    })
  }, [cupId, cupSeriesId, rifleCupSeriesId])

  return { fetching, error, cupSeries }
}

export default useCupSeries
