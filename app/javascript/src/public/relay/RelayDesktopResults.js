import React, { useCallback, useState } from 'react'
import useTranslation from '../../util/useTranslation'
import NoResultReason from '../NoResultReason'
import RelayTime from './RelayTime'
import RelayTimeAdjustment from './RelayTimeAdjustment'
import Button from '../../common/Button'

export default function RelayDesktopResults({ race, relay, teams }) {
  const { t } = useTranslation()
  const [showCompetitors, setShowCompetitors] = useState(false)
  const toggleCompetitors = useCallback(() => setShowCompetitors(show => !show), [])
  return (
    <div className="results--desktop">
      <div className="buttons">
        <Button onClick={toggleCompetitors}>{t(showCompetitors ? 'hideCompetitors' : 'showCompetitors')}</Button>
      </div>
      <table className="results-table">
        <thead>
          <tr>
            <th />
            <th>{t('team')}</th>
            <th>{t('numberShort')}</th>
            <th>{t(`timeTitle_${race.sportKey}`)}</th>
            {showCompetitors && <th className="center">{t('legTime')}</th>}
            <th>{t('estimatePenalties')}</th>
            <th>{t('shootingPenalties')}</th>
          </tr>
        </thead>
        <tbody>
          {teams.map((team, i) => {
            const { estimatePenaltiesSum, id, name, noResultReason, number, shootPenaltiesSum } = team
            return (
              <React.Fragment key={id}>
                <tr id={`team_${i + 1}`}>
                  <td>{i + 1}.</td>
                  <td className="team_name">{name}</td>
                  <td className="center">{number}</td>
                  <td className="center team_points">
                    {noResultReason && <NoResultReason noResultReason={noResultReason} type="team" />}
                    <RelayTime
                      noResultReason={noResultReason}
                      timeInSeconds={team.timeInSeconds}
                      timeWithPenalties={team.timeWithPenalties}
                    />
                    <RelayTimeAdjustment
                      adjustment={team.adjustment}
                      estimateAdjustment={team.estimateAdjustment}
                      shootingAdjustment={team.shootingAdjustment}
                    />
                  </td>
                  {showCompetitors && <td />}
                  <td className="center">{estimatePenaltiesSum}</td>
                  <td className="center">{shootPenaltiesSum}</td>
                </tr>
                {showCompetitors && team.competitors.map(competitor => {
                  const { estimate, estimatePenalties, firstName, lastName, leg, misses } = competitor
                  return (
                    <tr key={leg}>
                      <td />
                      <td>{lastName} {firstName}</td>
                      <td className="center">({leg})</td>
                      <td className="center">
                        <RelayTime
                          timeInSeconds={competitor.cumulativeTime}
                          timeWithPenalties={competitor.cumulativeTimeWithPenalties}
                        />
                        <RelayTimeAdjustment
                          adjustment={competitor.adjustment}
                          estimateAdjustment={competitor.estimateAdjustment}
                          shootingAdjustment={competitor.shootingAdjustment}
                        />
                      </td>
                      <td className="center">
                        <RelayTime
                          timeInSeconds={competitor.timeInSeconds}
                          timeWithPenalties={competitor.timeWithPenalties}
                        />
                      </td>
                      <td className="center">
                        {estimatePenalties}
                        {relay.finished && estimate && ` (${estimate}m)`}
                      </td>
                      <td className="center">{misses}</td>
                    </tr>
                  )
                })}
              </React.Fragment>
            )
          })}
        </tbody>
      </table>
    </div>
  )
}
