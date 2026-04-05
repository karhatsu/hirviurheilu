import useTranslation from '../../util/useTranslation'
import { resolveClubTitle } from '../../util/clubUtil'

const ClubExtraScoreFormRow = ({ race, clubExtraShots, onChange }) => {
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
            placeholder={t(`teamCompetitionExtraShotsPlaceholderNordic${n}`)}
            value={clubExtraShots[`score${n}`]}
            onChange={onChange(`score${n}`)}
          />
        </div>
      ))}
    </div>
  )
}

export default ClubExtraScoreFormRow
