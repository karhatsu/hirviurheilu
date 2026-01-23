import { useMemo } from 'react'

const useRelaySorting = (relay, leg) => {
  const teams = useMemo(() => {
    if (!relay) return []
    if (leg) {
      const { teamIds } = relay.legResults[leg - 1]
      return teamIds.map((teamId) => relay.teams.find((team) => team.id === teamId))
    } else {
      return relay.teams
    }
  }, [relay, leg])
  return { teams }
}

export default useRelaySorting
