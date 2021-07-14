import { useEffect, useState } from 'react'

const useRelaySorting = (relay, leg) => {
  const [teams, setTeams] = useState([])
  useEffect(() => {
    if (relay) {
      if (leg) {
        const { teamIds } = relay.legResults[leg - 1]
        setTeams(teamIds.map(teamId => relay.teams.find(team => team.id === teamId)))
      } else {
        setTeams(relay.teams)
      }
    }
  }, [relay, leg])
  return { teams }
}

export default useRelaySorting
