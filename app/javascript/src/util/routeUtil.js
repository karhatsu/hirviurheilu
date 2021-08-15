const withLocale = path => {
  const appElement = document.getElementById('react-app')
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

export const buildOfficialPath = () => withLocale('/official')

export const matchPath = (currentPath, path, exact) => {
  if (exact) {
    return currentPath === path || currentPath === `/sv${path}`
  }
  return currentPath.indexOf(path) === 0 || currentPath.indexOf(`/sv${path}`) === 0
}
