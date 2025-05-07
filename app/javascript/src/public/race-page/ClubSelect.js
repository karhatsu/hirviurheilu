import { raceEnums } from '../../util/enums'
import useTranslation from '../../util/useTranslation'

export default function ClubSelect({ clubLevel, clubs, multiple, onChange }) {
  const { t } = useTranslation()
  return (
    <select name="club_id" multiple={multiple} onChange={onChange}>
      {!multiple && (
        <option value={''}>{t(clubLevel === raceEnums.clubLevel.club ? 'allClubs' : 'allDistricts')}</option>
      )}
      {clubs.map((club) => {
        return (
          <option key={club.id} value={club.id}>
            {club.name}
          </option>
        )
      })}
    </select>
  )
}
