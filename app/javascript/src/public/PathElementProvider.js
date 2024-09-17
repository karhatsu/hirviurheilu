import React, { createContext, useContext, useMemo } from 'react'
import { useMatch } from 'react-router-dom'

const PathElementsContext = createContext()

export const usePathParams = () => useContext(PathElementsContext)

export const PathParamsContextProvider = ({ children }) => {
  const raceMatch = useMatch('/races/:raceId/*')
  const seriesMatch = useMatch('/races/:raceId/series/:seriesId/*')
  const teamCompetitionMatch = useMatch('/races/:raceId/team_competitions/:teamCompetitionId/*')
  const rifleTeamCompetitionMatch = useMatch('/races/:raceId/rifle_team_competitions/:teamCompetitionId/*')
  const relayMatch = useMatch('/races/:raceId/relays/:relayId/*')
  const cupMatch = useMatch('/cups/:cupId/*')
  const cupSeriesMatch = useMatch('/cups/:cupId/cup_series/:cupSeriesId/*')
  const rifleCupSeriesMatch = useMatch('/cups/:cupId/cup_series/:rifleCupSeriesId/*')
  const cupTeamCompetitionMatch = useMatch('/cups/:cupId/cup_team_competitions/:cupTeamCompetitionId/*')
  const value = useMemo(() => ({
    raceId: raceMatch?.params.raceId,
    seriesId: seriesMatch?.params.seriesId,
    teamCompetitionId: teamCompetitionMatch?.params.teamCompetitionId ||
      rifleTeamCompetitionMatch?.params.teamCompetitionId,
    relayId: relayMatch?.params.relayId,
    cupId: cupMatch?.params.cupId,
    cupSeriesId: cupSeriesMatch?.params.cupSeriesId,
    rifleCupSeriesId: rifleCupSeriesMatch?.params.rifleCupSeriesId,
    cupTeamCompetitionId: cupTeamCompetitionMatch?.params.cupTeamCompetitionId,
  }), [
    raceMatch,
    seriesMatch,
    teamCompetitionMatch,
    rifleTeamCompetitionMatch,
    relayMatch,
    cupMatch,
    cupSeriesMatch,
    rifleCupSeriesMatch,
    cupTeamCompetitionMatch,
  ])
  return <PathElementsContext.Provider value={value}>{children}</PathElementsContext.Provider>
}
