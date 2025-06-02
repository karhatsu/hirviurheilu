import { raceEnums } from './enums'

export const resolveClubTitle = (t, clubLevel) => {
  switch (clubLevel) {
    case raceEnums.clubLevel.club:
      return t('club')
    case raceEnums.clubLevel.district:
      return t('district')
    case raceEnums.clubLevel.country:
      return t('country')
  }
}

export const resolveClubsTitle = (t, clubLevel) => {
  switch (clubLevel) {
    case raceEnums.clubLevel.club:
      return t('clubs')
    case raceEnums.clubLevel.district:
      return t('districts')
    case raceEnums.clubLevel.country:
      return t('countries')
  }
}

export const findClubById = (clubs, clubId) => clubs.find((s) => s.id === clubId)
