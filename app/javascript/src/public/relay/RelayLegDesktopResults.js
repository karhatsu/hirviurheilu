import React from 'react'
import useTranslation from '../../util/useTranslation'
import RelayTime from './RelayTime'
import RelayTimeAdjustment from './RelayTimeAdjustment'

export default function RelayLegDesktopResults({ race, relay, teams, leg }) {
  const { t } = useTranslation()
  return (
    <div className="results--desktop">
      <table className="results-table">
        <thead>
          <tr>
            <th />
            <th>{t('team')}</th>
            <th>{t('competitor')}</th>
            <th>{t('numberShort')}</th>
            <th className="center">{t(`timeTitle_${race.sportKey}`)}</th>
            {leg > 1 && <th className="center">{t('legTime')}</th>}
            <th>{t('estimatePenalties')}</th>
            <th>{t('shootingPenalties')}</th>
          </tr>
        </thead>
        <tbody>
          {teams.map((team, i) => {
            const competitor = team.competitors[leg - 1]
            const {
              adjustment,
              cumulativeTime,
              cumulativeTimeWithPenalties,
              estimate,
              estimateAdjustment,
              estimatePenalties,
              firstName,
              lastName,
              misses,
              shootingAdjustment,
              timeInSeconds,
              timeWithPenalties,
            } = competitor
            return (
              <tr key={team.id} id={`team_${i + 1}`}>
                <td>{i + 1}.</td>
                <td>{team.name}</td>
                <td>{lastName} {firstName}</td>
                <td className="center">{team.number}</td>
                <td className="center team_points">
                  <RelayTime timeInSeconds={cumulativeTime} timeWithPenalties={cumulativeTimeWithPenalties} />
                  <RelayTimeAdjustment
                    adjustment={adjustment}
                    estimateAdjustment={estimateAdjustment}
                    shootingAdjustment={shootingAdjustment}
                  />
                </td>
                {leg > 1 && (
                  <td className="center">
                    <RelayTime timeInSeconds={timeInSeconds} timeWithPenalties={timeWithPenalties} />
                  </td>
                )}
                <td className="center">
                  {estimatePenalties}
                  {relay.finished && estimate && ` (${estimate}m)`}
                </td>
                <td className="center">{misses}</td>
              </tr>
            )
          })}
        </tbody>
      </table>
    </div>
  )
}
