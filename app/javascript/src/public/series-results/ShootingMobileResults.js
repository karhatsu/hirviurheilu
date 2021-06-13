import React from 'react'
import NationalRecord from './NationalRecord'
import useTranslation from '../../util/useTranslation'
import ShootingRaceMobileShootingResult from './ShootingRaceMobileShootingResult'
import TotalScore from './TotalScore'
import MobileResultCards from './MobileResultCards'

export default function ShootingMobileResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors } = series
  return (
    <MobileResultCards competitors={competitors}>
      {competitor => {
        const {
          club,
          extraShots,
          firstName,
          lastName,
          noResultReason,
          shootingScore,
        } = competitor
        return (
          <>
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
          </>
        )
      }}
    </MobileResultCards>
  )
}
