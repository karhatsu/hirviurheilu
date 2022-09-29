const withLocale = path => {
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

export const buildSeriesStartListPath = (raceId, seriesId) => withLocale(`/races/${raceId}/series/${seriesId}/start_list`)

export const buildSeriesResultsPath = (raceId, seriesId) => withLocale(`/races/${raceId}/series/${seriesId}`)

export const buildSeriesRifleResultsPath = (raceId, seriesId) => withLocale(`/races/${raceId}/series/${seriesId}/rifle`)

export const buildNordicResultsPath = (raceId, subSport) => withLocale(`/races/${raceId}/${subSport}`)

export const buildNordicSeriesResultsPath = (raceId, seriesId, subSport) => withLocale(`/races/${raceId}/series/${seriesId}/${subSport}`)

export const buildTeamCompetitionsPath = (raceId, id) => withLocale(`/races/${raceId}/team_competitions/${id}`)

export const buildRifleTeamCompetitionsPath = (raceId, id) => withLocale(`/races/${raceId}/rifle_team_competitions/${id}`)

export const buildRelayPath = (raceId, relayId) => withLocale(`/races/${raceId}/relays/${relayId}`)

export const buildRelayStartListPath = (raceId, relayId) => withLocale(`/races/${raceId}/relays/${relayId}/start_list.pdf`)

export const buildRelayLegPath = (raceId, relayId, leg) => withLocale(`/races/${raceId}/relays/${relayId}/legs/${leg}`)

export const buildQualificationRoundBatchesPath = raceId => withLocale(`/races/${raceId}/qualification_round_batches`)

export const buildFinalRoundBatchesPath = raceId => withLocale(`/races/${raceId}/final_round_batches`)

export const buildResultRotationPath = raceId => withLocale(`/races/${raceId}/result_rotation`)

export const buildRaceMediaPath = raceId => withLocale(`/races/${raceId}/medium/new`)

export const buildCupPath = cupId => withLocale(`/cups/${cupId}`)

export const buildCupSeriesPath = (cupId, cupSeriesId) => withLocale(`/cups/${cupId}/cup_series/${cupSeriesId}`)

export const buildRifleCupSeriesPath = (cupId, cupSeriesId) => withLocale(`/cups/${cupId}/rifle_cup_series/${cupSeriesId}`)

export const buildCupMediaPath = cupId => withLocale(`/cups/${cupId}/medium/new`)

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

export const buildOfficialRacePath = raceId => withLocale(`/official/races/${raceId}`)

export const buildOfficialRaceEditPath = raceId => withLocale(`/official/races/${raceId}/edit`)

export const buildOfficialRaceCompetitorsPath = seriesId => withLocale(`/official/series/${seriesId}/competitors`)

export const buildOfficialRaceStartListPath = seriesId => withLocale(`/official/races/${seriesId}/start_list`)

export const buildOfficialRaceQualificationRoundBatchListPath = seriesId => withLocale(`/official/series/${seriesId}/qualification_round_batch_list`)

export const buildOfficialRaceFinalRoundBatchListPath = seriesId => withLocale(`/official/series/${seriesId}/final_round_batch_list`)

export const buildOfficialRaceBatchesPath = raceId => withLocale(`/official/races/${raceId}/batches`)

export const buildOfficialRaceQuickSavesPath = raceId => withLocale(`/official/races/${raceId}/quick_saves`)

export const buildOfficialSeriesTimesPath = seriesId => withLocale(`/official/series/${seriesId}/times`)

export const buildOfficialSeriesEstimatesPath = seriesId => withLocale(`/official/series/${seriesId}/estimates`)

export const buildOfficialSeriesShotsPath = seriesId => withLocale(`/official/series/${seriesId}/shots`)

export const buildOfficialRaceShootingByBatchesPath = raceId => withLocale(`/official/races/${raceId}/shooting_by_batches`)

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
