import React from 'react'
import useTranslation from '../../util/useTranslation'
import UnofficialLabel from './UnofficialLabel'
import Points from './Points'
import NationalRecord from './NationalRecord'
import MobileSubResult from './MobileSubResult'
import EstimatePoints from './EstimatePoints'
import TimePoints from './TimePoints'
import ShootingPoints from './ShootingPoints'

export default function ThreeSportMobileResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors, timePoints } = series
  let prevCompetitorPosition = 0
  return (
    <div className="results--mobile">
      <div className="result-cards">
        {competitors.map((competitor, i) => {
          const {
            ageGroup,
            arrivalTime,
            club,
            estimatePoints,
            firstName,
            id,
            lastName,
            noResultReason,
            points,
            position,
            shootingScore,
            unofficial,
          } = competitor
          const orderNo = position === prevCompetitorPosition ? '' : `${position}.`
          prevCompetitorPosition = position
          return (
            <div className={`card ${i % 2 === 0 ? 'card--odd' : ''}`} key={id}>
              <div className="card__number">{orderNo}</div>
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
                    {estimatePoints !== 'undefined' && (
                      <MobileSubResult type="estimate">
                        <EstimatePoints race={race} series={series} competitor={competitor} />
                      </MobileSubResult>
                    )}
                    {arrivalTime && timePoints && (
                      <MobileSubResult type="time">
                        <TimePoints series={series} competitor={competitor} />
                      </MobileSubResult>
                    )}
                    {shootingScore !== 'undefined' && (
                      <MobileSubResult type="shoot"><ShootingPoints competitor={competitor} /></MobileSubResult>
                    )}
                  </div>
                )}
              </div>
              <div className="card__main-value">
                <Points competitor={competitor} />
                <NationalRecord race={race} series={series} competitor={competitor} />
              </div>
            </div>
          )
        })}
      </div>
    </div>
  )
}
