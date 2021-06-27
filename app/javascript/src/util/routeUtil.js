export const buildRacePath = raceId => `/races/${raceId}`

export const buildSeriesStartListPath = (raceId, seriesId) => `/races/${raceId}/series/${seriesId}/start_list`

export const buildSeriesResultsPath = (raceId, seriesId) => `/races/${raceId}/series/${seriesId}`

export const buildSeriesRifleResultsPath = (raceId, seriesId) => `/races/${raceId}/series/${seriesId}/rifle`

export const buildNordicResultsPath = (raceId, subSport) => `/races/${raceId}/${subSport}`

export const buildTeamCompetitionsPath = (raceId, id) => `/races/${raceId}/team_competitions/${id}`

export const buildRifleTeamCompetitionsPath = (raceId, id) => `/races/${raceId}/rifle_team_competitions/${id}`

export const buildRelayPath = (raceId, relayId) => `/races/${raceId}/relays/${relayId}`

export const buildRelayStartListPath = (raceId, relayId) => `/races/${raceId}/relays/${relayId}/start_list.pdf`

export const buildRelayLegPath = (relayId, leg) => `/relays/${relayId}/legs/${leg}`

export const buildQualificationRoundBatchesPath = raceId => `/races/${raceId}/qualification_round_batches`

export const buildFinalRoundBatchesPath = raceId => `/races/${raceId}/final_round_batches`

export const buildCupPath = cupId => `/cups/${cupId}`
