import React from 'react'
import classnames from 'classnames-minimal'
import RelayTime from './RelayTime'
import MobileSubResult from '../series-results/MobileSubResult'
import { timeFromSeconds } from '../../util/timeUtil'

export default function RelayLegMobileResults({ relay, teams, leg }) {
  return (
    <div className="results--mobile result-cards">
      {teams.map((team, i) => {
        const className = classnames({ card: true, 'card--odd': i % 2 === 0 })
        const competitor = team.competitors[leg - 1]
        const {
          adjustment,
          cumulativeTime,
          cumulativeTimeWithPenalties,
          estimate: estimateMeters,
          estimateAdjustment,
          estimatePenalties,
          estimatePenaltySeconds,
          firstName,
          lastName,
          misses,
          shootingAdjustment,
          shootingPenaltySeconds,
          timeInSeconds,
          timeWithPenalties,
        } = competitor

        const estimateWithMeters = relay.finished && estimatePenalties !== null
          ? `${estimatePenalties} / ${estimateMeters}m`
          : estimatePenalties
        const estimate = relay.estimatePenaltySeconds && estimatePenaltySeconds
          ? `${timeFromSeconds(estimatePenaltySeconds, true)} (${estimateWithMeters})`
          : estimateWithMeters
        const estimateAdjustmentText = estimateAdjustment
          ? `Arviokorjaus ${timeFromSeconds(estimateAdjustment, true)}`
          : undefined

        const shooting = relay.shootingPenaltySeconds && misses
          ? `${timeFromSeconds(shootingPenaltySeconds, true)} (${misses})`
          : misses
        const shootingAdjustmentText = shootingAdjustment
          ? `Ammuntakorjaus ${timeFromSeconds(shootingAdjustment, true)}`
          : undefined
        const adjustmentText = adjustment ? `Aikakorjaus ${timeFromSeconds(adjustment, true)}` : undefined

        return (
          <div className={className} key={team.id}>
            <div className="card__number">{i + 1}.</div>
            <div className="card__middle">
              <div className="card__name">{team.name} / {lastName} {firstName}</div>
              {!team.noResultReason && (
                <div className="card__middle-row">
                  {relay.penaltySeconds && timeInSeconds && (
                    <MobileSubResult type="time">
                      {timeFromSeconds(timeInSeconds)}
                    </MobileSubResult>
                  )}
                  {estimate !== null && (
                    <MobileSubResult type="estimate" adjustment={estimateAdjustmentText}>{estimate}</MobileSubResult>
                  )}
                  {misses !== null && (
                    <MobileSubResult type="shoot" adjustment={shootingAdjustmentText}>{shooting}</MobileSubResult>
                  )}
                  {adjustmentText}
                </div>
              )}
            </div>
            <div className="card__main-value">
              <RelayTime timeInSeconds={cumulativeTimeWithPenalties || cumulativeTime} />
              {leg > 1 && (
                <div>
                  (<RelayTime timeInSeconds={timeWithPenalties || timeInSeconds} />)
                </div>
              )}
            </div>
          </div>
        )
      })}
    </div>
  )
}
