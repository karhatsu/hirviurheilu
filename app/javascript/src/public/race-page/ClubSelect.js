import React from 'react'
import { raceEnums } from '../../util/enums'
import useTranslation from '../../util/useTranslation'

export default function ClubSelect({ clubLevel, clubs }) {
  const { t } = useTranslation()
  return (
    <select name="club_id">
      <option>{t(clubLevel === raceEnums.clubLevel.club ? 'allClubs' : 'allDistricts') }</option>
      {clubs.map(club => {
        return <option key={club.id} value={club.id}>{club.name}</option>
      })}
    </select>
  )
}
