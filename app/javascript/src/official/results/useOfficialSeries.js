import { useEffect, useState } from "react"
import { get } from "../../util/apiClient"
import { useParams } from "react-router"

const useOfficialSeries = () => {
  const { raceId, seriesId} = useParams()
  const [series, setSeries] = useState()
  const [error, setError] = useState()
  const [fetching, setFetching] = useState(true)

  useEffect(() => {
    setFetching(true)
    get(`/official/races/${raceId}/series/${seriesId}`, (err, response) => {
      if (err) setError(err)
      else setSeries(response)
      setFetching(false)
    })
  }, [raceId, seriesId])

  return { error, fetching, series }
}

export default useOfficialSeries
