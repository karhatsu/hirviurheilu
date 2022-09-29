import { raceEnums } from './enums'

export const resolveClubTitle = (t, clubLevel) => t(clubLevel === raceEnums.clubLevel.club ? 'club' : 'district')

export const resolveClubsTitle = (t, clubLevel) => t(clubLevel === raceEnums.clubLevel.club ? 'clubs' : 'districts')
