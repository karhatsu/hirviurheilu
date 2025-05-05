import { createContext, useContext, useMemo } from 'react'
import { useMatch } from 'react-router'

const PathElementsContext = createContext(undefined)

export const usePathParams = () => useContext(PathElementsContext)

export const PathParamsContextProvider = ({ children }) => {
  const raceMatch = useMatch('/races/:raceId/*')
  const raceMatchSv = useMatch('/sv/races/:raceId/*')
  const officialRaceMatch = useMatch('/official/races/:raceId/*')
  const officialRaceMatchSv = useMatch('/sv/official/races/:raceId/*')
  const seriesMatch = useMatch('/races/:raceId/series/:seriesId/*')
  const seriesMatchSv = useMatch('/sv/races/:raceId/series/:seriesId/*')
  const teamCompetitionMatch = useMatch('/races/:raceId/team_competitions/:teamCompetitionId/*')
  const teamCompetitionMatchSv = useMatch('/sv/races/:raceId/team_competitions/:teamCompetitionId/*')
  const rifleTeamCompetitionMatch = useMatch('/races/:raceId/rifle_team_competitions/:teamCompetitionId/*')
  const rifleTeamCompetitionMatchSv = useMatch('/sv/races/:raceId/rifle_team_competitions/:teamCompetitionId/*')
  const relayMatch = useMatch('/races/:raceId/relays/:relayId/*')
  const relayMatchSv = useMatch('/sv/races/:raceId/relays/:relayId/*')
  const cupMatch = useMatch('/cups/:cupId/*')
  const cupMatchSv = useMatch('/sv/cups/:cupId/*')
  const cupSeriesMatch = useMatch('/cups/:cupId/cup_series/:cupSeriesId/*')
  const cupSeriesMatchSv = useMatch('/sv/cups/:cupId/cup_series/:cupSeriesId/*')
  const rifleCupSeriesMatch = useMatch('/cups/:cupId/rifle_cup_series/:rifleCupSeriesId/*')
  const rifleCupSeriesMatchSv = useMatch('/sv/cups/:cupId/rifle_cup_series/:rifleCupSeriesId/*')
  const cupTeamCompetitionMatch = useMatch('/cups/:cupId/cup_team_competitions/:cupTeamCompetitionId/*')
  const cupTeamCompetitionMatchSv = useMatch('/sv/cups/:cupId/cup_team_competitions/:cupTeamCompetitionId/*')
  const officialSeriesMatch = useMatch('/official/races/:raceId/series/:seriesId/*')
  const officialSeriesMatchSv = useMatch('/sv/official/races/:raceId/series/:seriesId/*')
  const eventMatch = useMatch('/official/events/:eventId/*')
  const eventMatchSv = useMatch('/sv/official/events/:eventId/*')
  const eventId = eventMatch && eventMatch.params.eventId !== 'new' ? eventMatch.params.eventId : undefined
  const eventIdSv = eventMatch && eventMatchSv.params.eventId !== 'new' ? eventMatchSv.params.eventId : undefined
  const value = useMemo(() => ({
    raceId: (raceMatch || raceMatchSv || officialRaceMatch || officialRaceMatchSv)?.params.raceId,
    seriesId: (seriesMatch || seriesMatchSv || officialSeriesMatch || officialSeriesMatchSv)?.params.seriesId,
    teamCompetitionId: (teamCompetitionMatch
      || teamCompetitionMatchSv || rifleTeamCompetitionMatch || rifleTeamCompetitionMatchSv)?.params.teamCompetitionId,
    relayId: (relayMatch || relayMatchSv)?.params.relayId,
    cupId: (cupMatch || cupMatchSv)?.params.cupId,
    cupSeriesId: (cupSeriesMatch || cupSeriesMatchSv)?.params.cupSeriesId,
    rifleCupSeriesId: (rifleCupSeriesMatch || rifleCupSeriesMatchSv)?.params.rifleCupSeriesId,
    cupTeamCompetitionId: (cupTeamCompetitionMatch || cupTeamCompetitionMatchSv)?.params.cupTeamCompetitionId,
    eventId: eventId || eventIdSv,
  }), [
    raceMatch,
    raceMatchSv,
    officialRaceMatch,
    officialRaceMatchSv,
    seriesMatch,
    seriesMatchSv,
    officialSeriesMatch,
    officialSeriesMatchSv,
    teamCompetitionMatch,
    teamCompetitionMatchSv,
    rifleTeamCompetitionMatch,
    rifleTeamCompetitionMatchSv,
    relayMatch,
    relayMatchSv,
    cupMatch,
    cupMatchSv,
    cupSeriesMatch,
    cupSeriesMatchSv,
    rifleCupSeriesMatch,
    rifleCupSeriesMatchSv,
    cupTeamCompetitionMatch,
    cupTeamCompetitionMatchSv,
    eventId,
    eventIdSv,
  ])
  return <PathElementsContext value={value}>{children}</PathElementsContext>
}
