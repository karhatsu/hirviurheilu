import React from 'react'
import classnames from 'classnames-minimal'
import NoResultReason from '../NoResultReason'
import RelayTime from './RelayTime'
import { timeFromSeconds } from '../../util/timeUtil'
import MobileSubResult from '../series-results/MobileSubResult'

export default function RelayMobileResults({ race, relay }) {
  return (
    <div className="results--mobile result-cards">
      {relay.teams.map((team, i) => {
        const {
          adjustment,
          estimateAdjustment,
          estimatePenaltySeconds,
          estimatePenaltiesSum,
          id,
          name,
          noResultReason,
          shootingAdjustment,
          shootingPenaltySeconds,
          shootPenaltiesSum,
          timeInSeconds,
          timeWithPenalties,
        } = team
        const className = classnames({ card: true, 'card--odd': i % 2 === 0 })

        const estimate = relay.estimatePenaltySeconds && estimatePenaltiesSum
          ? `${timeFromSeconds(estimatePenaltySeconds, true)} (${estimatePenaltiesSum})`
          : estimatePenaltiesSum
        const estimateAdjustmentText = estimateAdjustment
          ? `Arviokorjaus ${timeFromSeconds(estimateAdjustment, true)}`
          : undefined

        const shooting = relay.shootingPenaltySeconds && shootPenaltiesSum
          ? `${timeFromSeconds(shootingPenaltySeconds, true)} (${shootPenaltiesSum})`
          : shootPenaltiesSum
        const shootingAdjustmentText = shootingAdjustment
          ? `Ammuntakorjaus ${timeFromSeconds(shootingAdjustment, true)}`
          : undefined
        const adjustmentText = adjustment ? `Aikakorjaus ${timeFromSeconds(adjustment, true)}` : undefined

        return (
          <div key={id} className={className}>
            <div className="card__number">{i + 1}.</div>
            <div className="card__middle">
              <div className="card__name">{name}</div>
              {!noResultReason && (
                <div className="card__middle-row">
                  {relay.penaltySeconds && timeInSeconds && (
                    <MobileSubResult type="time">
                      {timeFromSeconds(timeInSeconds)}
                    </MobileSubResult>
                  )}
                  {estimatePenaltiesSum !== null && (
                    <MobileSubResult type="estimate" adjustment={estimateAdjustmentText}>{estimate}</MobileSubResult>
                  )}
                  {shootPenaltiesSum !== null && (
                    <MobileSubResult type="shoot" adjustment={shootingAdjustmentText}>{shooting}</MobileSubResult>
                  )}
                  {adjustmentText}
                </div>
              )}
            </div>
            <div className="card__main-value">
              {noResultReason && <NoResultReason noResultReason={noResultReason} type="team" />}
              <RelayTime
                noResultReason={noResultReason}
                timeInSeconds={timeInSeconds}
                timeWithPenalties={timeWithPenalties}
                rowBreak={true}
              />
            </div>
          </div>
        )
      })}
    </div>
  )
}
