import { useEffect, useState } from 'react'
import { get } from '../../util/apiClient'
import { useParams } from 'react-router'

const useOfficialRaceCompetitors = () => {
  const { raceId } = useParams()
  const [competitors, setCompetitors] = useState()
  const [error, setError] = useState()
  const [fetching, setFetching] = useState(true)

  useEffect(() => {
    setFetching(true)
    get(`/official/races/${raceId}/competitors.json`, (err, response) => {
      if (err) setError(err)
      else setCompetitors(response.competitors)
      setFetching(false)
    })
  }, [raceId])

  return { error, fetching, competitors, setCompetitors }
}

export default useOfficialRaceCompetitors
