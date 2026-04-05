import useTranslation from '../../util/useTranslation'
import { resolveClubTitle } from '../../util/clubUtil'

const ClubExtraShotsFormRow = ({ race, clubExtraShots, onChange, resultKey }) => {
  const { t } = useTranslation()
  return (
    <div className="form__horizontal-fields">
      <div className="form__field form__field--md">
        <select value={clubExtraShots.clubId} onChange={onChange('clubId')}>
          <option value="">- {resolveClubTitle(t, race.clubLevel)} -</option>
          {race.clubs.map((club) => (
            <option key={club.id} value={club.id}>
              {club.name}
            </option>
          ))}
        </select>
      </div>
      {[1, 2].map((n) => (
        <div key={n} className="form__field form__field--md">
          <input
            type="text"
            placeholder={t(`teamCompetitionExtraShotsPlaceholder_${resultKey}${n}`)}
            value={clubExtraShots[`${resultKey}${n}`]}
            onChange={onChange(`${resultKey}${n}`)}
          />
        </div>
      ))}
    </div>
  )
}

export default ClubExtraShotsFormRow
