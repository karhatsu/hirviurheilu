import useTranslation from '../../util/useTranslation'
import UnofficialLabel from '../series-results/UnofficialLabel'
import { resolveClubTitle } from '../../util/clubUtil'

export default function DesktopStartList({ competitors, race }) {
  const { t } = useTranslation()

  const showTeamName = !!competitors.find((c) => c.teamName)
  return (
    <div className="results--desktop">
      <table className="results-table">
        <thead>
          <tr>
            <th>{t('numberShort')}</th>
            <th>{t('competitor')}</th>
            <th id="table_club_title">{resolveClubTitle(t, race.clubLevel)}</th>
            <th>{t('startTime')}</th>
            {showTeamName && <th>{t('team')}</th>}
          </tr>
        </thead>
        <tbody>
          {competitors.map((competitor, i) => {
            const {
              ageGroup,
              club,
              firstName,
              lastName,
              number,
              relativeStartTime,
              realStartTime,
              unofficial,
              teamName,
            } = competitor
            const time =
              realStartTime && realStartTime !== relativeStartTime
                ? `${relativeStartTime} (${realStartTime})`
                : relativeStartTime
            return (
              <tr key={competitor.id} className={i % 2 === 0 ? 'odd' : ''} id={`comp_${i + 1}`}>
                <td>{number}</td>
                <td>
                  {lastName} {firstName}
                  {ageGroup && ` (${ageGroup.name})`}
                  <UnofficialLabel unofficial={unofficial} />
                </td>
                <td>{club.name}</td>
                <td>{time}</td>
                {showTeamName && <td>{teamName}</td>}
              </tr>
            )
          })}
        </tbody>
      </table>
    </div>
  )
}
