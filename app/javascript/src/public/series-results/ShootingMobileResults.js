import React from 'react'
import NationalRecord from './NationalRecord'
import useTranslation from '../../util/useTranslation'
import ShootingRaceMobileShootingResult from './ShootingRaceMobileShootingResult'
import TotalScore from './TotalScore'

export default function ShootingMobileResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors } = series
  let prevCompetitorPosition = 0
  return (
    <div className="results--mobile result-cards">
      {competitors.map((competitor, i) => {
        const {
          club,
          extraShots,
          firstName,
          id,
          lastName,
          noResultReason,
          position,
          shootingScore,
        } = competitor
        const orderNo = position === prevCompetitorPosition ? '' : `${position}.`
        prevCompetitorPosition = position
        return (
          <div key={id} className={`card ${i % 2 === 0 ? 'card--odd' : ''}`}>
            <div className="card__number">{orderNo}</div>
            <div className="card__middle">
              <div className="card__name">{lastName} {firstName}</div>
              <div className="card__middle-row">{club.name}</div>
              <ShootingRaceMobileShootingResult competitor={competitor} />
              {extraShots && (
                <div className="card__middle-row">
                  {t('extraRound')}: {extraShots.join(', ')}
                </div>
              )}
            </div>
            <div className="card__main-value">
              <TotalScore noResultReason={noResultReason} totalScore={shootingScore} />
              <NationalRecord race={race} series={series} competitor={competitor} />
            </div>
          </div>
        )
      })}
    </div>
  )
}
