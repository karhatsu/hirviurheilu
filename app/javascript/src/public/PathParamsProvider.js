import { createContext, useContext, useMemo } from 'react'
import { useMatch } from 'react-router'

const PathElementsContext = createContext(undefined)

export const usePathParams = () => useContext(PathElementsContext)

export const PathParamsContextProvider = ({ children }) => {
  const raceMatch = useMatch('/races/:raceId/*')
  const officialRaceMatch = useMatch('/official/races/:raceId/*')
  const seriesMatch = useMatch('/races/:raceId/series/:seriesId/*')
  const teamCompetitionMatch = useMatch('/races/:raceId/team_competitions/:teamCompetitionId/*')
  const rifleTeamCompetitionMatch = useMatch('/races/:raceId/rifle_team_competitions/:teamCompetitionId/*')
  const relayMatch = useMatch('/races/:raceId/relays/:relayId/*')
  const cupMatch = useMatch('/cups/:cupId/*')
  const cupSeriesMatch = useMatch('/cups/:cupId/cup_series/:cupSeriesId/*')
  const rifleCupSeriesMatch = useMatch('/cups/:cupId/rifle_cup_series/:rifleCupSeriesId/*')
  const cupTeamCompetitionMatch = useMatch('/cups/:cupId/cup_team_competitions/:cupTeamCompetitionId/*')
  const officialSeriesMatch = useMatch('/official/races/:raceId/series/:seriesId/*')
  const eventMatch = useMatch('/official/events/:eventId/*')
  const eventId = eventMatch && eventMatch.params.eventId !== 'new' ? eventMatch.params.eventId : undefined
  const value = useMemo(() => ({
    raceId: raceMatch?.params.raceId || officialRaceMatch?.params.raceId,
    seriesId: seriesMatch?.params.seriesId || officialSeriesMatch?.params.seriesId,
    teamCompetitionId: teamCompetitionMatch?.params.teamCompetitionId ||
      rifleTeamCompetitionMatch?.params.teamCompetitionId,
    relayId: relayMatch?.params.relayId,
    cupId: cupMatch?.params.cupId,
    cupSeriesId: cupSeriesMatch?.params.cupSeriesId,
    rifleCupSeriesId: rifleCupSeriesMatch?.params.rifleCupSeriesId,
    cupTeamCompetitionId: cupTeamCompetitionMatch?.params.cupTeamCompetitionId,
    eventId,
  }), [
    raceMatch,
    officialRaceMatch,
    seriesMatch,
    officialSeriesMatch,
    teamCompetitionMatch,
    rifleTeamCompetitionMatch,
    relayMatch,
    cupMatch,
    cupSeriesMatch,
    rifleCupSeriesMatch,
    cupTeamCompetitionMatch,
    eventId,
  ])
  return <PathElementsContext value={value}>{children}</PathElementsContext>
}
