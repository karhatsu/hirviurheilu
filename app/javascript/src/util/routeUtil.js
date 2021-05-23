export const buildRaceLink = raceId => `/races/${raceId}`

export const buildSeriesStartListLink = (raceId, seriesId) => `/races/${raceId}/series/${seriesId}/start_list`

export const buildSeriesResultsLink = (raceId, seriesId) => `/races/${raceId}/series/${seriesId}`

export const buildSeriesRifleResultsLink = (raceId, seriesId) => `/races/${raceId}/series/${seriesId}/rifle`

export const buildNordicResultsLink = (raceId, subSport) => `/races/${raceId}/${subSport}`

export const buildTeamCompetitionsLink = (raceId, id) => `/races/${raceId}/team_competitions/${id}`

export const buildRifleTeamCompetitionsLink = (raceId, id) => `/races/${raceId}/rifle_team_competitions/${id}`

export const buildRelayLink = (raceId, relayId) => `/races/${raceId}/relays/${relayId}`

export const buildQualificationRoundBatchesLink = raceId => `/races/${raceId}/qualification_round_batches`

export const buildFinalRoundBatchesLink = raceId => `/races/${raceId}/final_round_batches`

export const buildCupLink = cupId => `/cups/${cupId}`
