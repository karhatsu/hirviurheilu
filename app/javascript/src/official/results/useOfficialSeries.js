import { useEffect, useState } from "react"
import { get } from "../../util/apiClient"
import { useParams, useSearchParams } from "react-router"

const useOfficialSeries = () => {
  const { raceId, seriesId} = useParams()
  const [searchParams] = useSearchParams()
  const [series, setSeries] = useState()
  const [error, setError] = useState()
  const [fetching, setFetching] = useState(true)

  useEffect(() => {
    setFetching(true)
    let path = `/official/races/${raceId}/series/${seriesId}`
    if (searchParams.get('qualification_round')) path += '?qualification_round=true'
    get(path, (err, response) => {
      if (err) setError(err)
      else setSeries(response)
      setFetching(false)
    })
  }, [raceId, seriesId, searchParams])

  return { error, fetching, series }
}

export default useOfficialSeries
