export const withLocale = path => {
  const appElement = document.getElementsByClassName('react-app')[0]
  const locale = appElement.getAttribute('data-locale')
  if (path === '/' && locale === 'sv') return '/sv'
  return locale === 'sv' ? `/sv${path}` : path
}

/* eslint-disable max-len */
export const buildRootPath = () => withLocale('/')

export const buildRacesPath = () => withLocale('/races')

export const buildRacePath = raceId => withLocale(`/races/${raceId}`)

export const buildRaceStartListsPdfPath = raceId => withLocale(`/races/${raceId}/start_lists.pdf`)

export const buildRaceRifleResultsPath = (raceId) => withLocale(`/races/${raceId}/rifle`)

export const buildRaceShotgunsResultsPath = (raceId) => withLocale(`/races/${raceId}/shotguns`)

export const buildSeriesStartListPath = (raceId, seriesId) => withLocale(`/races/${raceId}/series/${seriesId}/start_list`)

export const buildSeriesResultsPath = (raceId, seriesId) => withLocale(`/races/${raceId}/series/${seriesId}`)

export const buildSeriesRifleResultsPath = (raceId, seriesId) => withLocale(`/races/${raceId}/series/${seriesId}/rifle`)

export const buildSeriesShotgunsResultsPath = (raceId, seriesId) => withLocale(`/races/${raceId}/series/${seriesId}/shotguns`)

export const buildNordicResultsPath = (raceId, subSport) => withLocale(`/races/${raceId}/${subSport}`)

export const buildNordicSeriesResultsPath = (raceId, seriesId, subSport) => withLocale(`/races/${raceId}/series/${seriesId}/${subSport}`)

export const buildTeamCompetitionsPath = (raceId, id) => withLocale(`/races/${raceId}/team_competitions/${id}`)

export const buildRifleTeamCompetitionsPath = (raceId, id) => withLocale(`/races/${raceId}/rifle_team_competitions/${id}`)

export const buildRelayPath = (raceId, relayId) => withLocale(`/races/${raceId}/relays/${relayId}`)

export const buildRelayStartListPath = (raceId, relayId) => withLocale(`/races/${raceId}/relays/${relayId}/start_list.pdf`)

export const buildRelayLegPath = (raceId, relayId, leg) => withLocale(`/races/${raceId}/relays/${relayId}/legs/${leg}`)

export const buildQualificationRoundHeatsPath = raceId => withLocale(`/races/${raceId}/qualification_round_heats`)

export const buildFinalRoundHeatsPath = raceId => withLocale(`/races/${raceId}/final_round_heats`)

export const buildResultRotationPath = raceId => withLocale(`/races/${raceId}/result_rotation`)

export const buildRacePressPath = raceId => withLocale(`/races/${raceId}/press`)

export const buildCupPath = cupId => withLocale(`/cups/${cupId}`)

export const buildCupSeriesPath = (cupId, cupSeriesId) => withLocale(`/cups/${cupId}/cup_series/${cupSeriesId}`)

export const buildRifleCupSeriesPath = (cupId, cupSeriesId) => withLocale(`/cups/${cupId}/rifle_cup_series/${cupSeriesId}`)

export const buildCupTeamCompetitionsPath = (cupId, cupTeamCompetitionId) => withLocale(`/cups/${cupId}/cup_team_competitions/${cupTeamCompetitionId}`)

export const buildCupPressPath = cupId => withLocale(`/cups/${cupId}/press`)

export const buildAnnouncementsPath = () => withLocale('/announcements')

export const buildAnnouncementPath = id => withLocale(`/announcements/${id}`)

export const buildRegisterPath = () => withLocale('/register')

export const buildAccountPath = () => withLocale('/account')

export const buildFeedbackPath = () => withLocale('/feedbacks/new')

export const buildInfoPath = () => withLocale('/info')

export const buildAnswersPath = () => withLocale('/answers')

export const buildPricesPath = () => withLocale('/prices')

export const buildSportsInfoPath = () => withLocale('/sports_info')

export const buildOfficialPath = () => withLocale('/official')

export const buildOfficialEventPath = eventId => withLocale(`/official/events/${eventId}`)

export const buildOfficialRacePath = raceId => withLocale(`/official/races/${raceId}`)

export const buildOfficialRaceEditPath = raceId => withLocale(`/official/races/${raceId}/edit`)

export const buildOfficialRaceCompetitorsPath = seriesId => withLocale(`/official/series/${seriesId}/competitors`)

export const buildOfficialRaceStartListPath = seriesId => withLocale(`/official/races/${seriesId}/start_list`)

export const buildOfficialRaceQualificationRoundHeatListPath = seriesId => withLocale(`/official/series/${seriesId}/qualification_round_heat_list`)

export const buildOfficialRaceFinalRoundHeatListPath = seriesId => withLocale(`/official/series/${seriesId}/final_round_heat_list`)

export const buildOfficialRaceHeatsPath = raceId => withLocale(`/official/races/${raceId}/heats`)

export const buildOfficialRaceQuickSavesPath = raceId => withLocale(`/official/races/${raceId}/quick_saves`)

export const buildOfficialSeriesTimesPath = seriesId => withLocale(`/official/series/${seriesId}/times`)

export const buildOfficialSeriesEstimatesPath = seriesId => withLocale(`/official/series/${seriesId}/estimates`)

export const buildOfficialSeriesShotsPath = seriesId => withLocale(`/official/series/${seriesId}/shots`)

export const buildOfficialRaceShootingByHeatsPath = raceId => withLocale(`/official/races/${raceId}/shooting_by_heats`)

export const buildOfficialRaceNordicPath = (raceId, subSport) => withLocale(`/official/races/${raceId}/nordic_${subSport}`)

export const buildOfficialRaceEuropeanPath = (raceId, subSport) => withLocale(`/official/races/${raceId}/european_${subSport}`)

export const buildOfficialRaceCorrectDistancesPath = raceId => withLocale(`/official/races/${raceId}/correct_estimates`)

export const buildOfficialRaceCsvPath = raceId => withLocale(`/official/races/${raceId}/csv_export`)

export const buildOfficialRaceTeamCompetitionsPath = raceId => withLocale(`/official/races/${raceId}/team_competitions`)

export const buildOfficialRaceRelaysPath = raceId => withLocale(`/official/races/${raceId}/relays`)

export const buildOfficialRaceClubsPath = raceId => withLocale(`/official/races/${raceId}/clubs`)

export const buildOfficialRaceOfficialsPath = raceId => withLocale(`/official/races/${raceId}/race_rights`)

export const matchPath = (currentPath, path, exact) => {
  if (exact) {
    return currentPath === path || currentPath === `/sv${path}`
  }
  return currentPath.indexOf(path) === 0 || currentPath.indexOf(`/sv${path}`) === 0
}
