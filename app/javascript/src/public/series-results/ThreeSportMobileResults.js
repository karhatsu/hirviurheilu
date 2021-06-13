import React from 'react'
import useTranslation from '../../util/useTranslation'
import UnofficialLabel from './UnofficialLabel'
import Points from './Points'
import NationalRecord from './NationalRecord'
import MobileSubResult from './MobileSubResult'
import EstimatePoints from './EstimatePoints'
import TimePoints from './TimePoints'
import ShootingPoints from './ShootingPoints'
import MobileResultCards from './MobileResultCards'

export default function ThreeSportMobileResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors, timePoints } = series
  return (
    <MobileResultCards competitors={competitors}>
      {competitor => {
        const {
          ageGroup,
          arrivalTime,
          club,
          estimatePoints,
          firstName,
          lastName,
          noResultReason,
          points,
          shootingScore,
          unofficial,
        } = competitor
        return (
          <>
            <div className="card__middle">
              <div className="card__name">
                {lastName} {firstName}
                {ageGroup && <div className="card__name__extra"> ({ageGroup.name})</div>}
                {unofficial && <div className="card__name__extra"><UnofficialLabel unofficial={unofficial}/></div>}
              </div>
              <div className="card__middle-row">{club.name}</div>
              {noResultReason && <div className="card__middle-row">{t(`competitor_${noResultReason}`)}</div>}
              {!noResultReason && points && (
                <div className="card__middle-row">
                  {typeof estimatePoints !== 'undefined' && (
                    <MobileSubResult type="estimate">
                      <EstimatePoints race={race} series={series} competitor={competitor} />
                    </MobileSubResult>
                  )}
                  {arrivalTime && timePoints && (
                    <MobileSubResult type="time">
                      <TimePoints series={series} competitor={competitor} />
                    </MobileSubResult>
                  )}
                  {typeof shootingScore !== 'undefined' && (
                    <MobileSubResult type="shoot"><ShootingPoints competitor={competitor} /></MobileSubResult>
                  )}
                </div>
              )}
            </div>
            <div className="card__main-value">
              <Points competitor={competitor} />
              <NationalRecord race={race} series={series} competitor={competitor} />
            </div>
          </>
        )
      }}
    </MobileResultCards>
  )
}
