import { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import { get } from '../../util/apiClient'

const useCupTeamCompetition = () => {
  const [fetching, setFetching] = useState(true)
  const { cupId, cupTeamCompetitionId } = useParams()
  const [cupTeamCompetition, setCupTeamCompetition] = useState()
  const [error, setError] = useState()

  useEffect(() => {
    setFetching(true)
    get(`/api/v2/public/cups/${cupId}/cup_team_competitions/${cupTeamCompetitionId}`, (err, data) => {
      if (err) return setError(err)
      setCupTeamCompetition(data)
      setFetching(false)
    })
  }, [cupId, cupTeamCompetitionId])

  return { fetching, error, cupTeamCompetition }
}

export default useCupTeamCompetition
