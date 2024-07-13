import React from 'react'
import useTranslation from '../../util/useTranslation'
import MobileResultCards from '../series-results/MobileResultCards'
import MobileSubResult from '../series-results/MobileSubResult'
import ShootingResult from '../series-results/ShootingResult'
import TotalScore from '../series-results/TotalScore'

export default function EuropeanShotgunMobileResults({ competitors }) {
  const { t } = useTranslation()
  return (
    <MobileResultCards competitors={competitors}>
      {competitor => {
        const {
          club,
          europeanShotgunExtraShots,
          europeanShotgunScore,
          europeanTrapScore,
          europeanTrapShots,
          europeanCompakScore,
          europeanCompakShots,
          firstName,
          lastName,
          noResultReason,
        } = competitor
        return (
          <>
            <div className="card__middle">
              <div className="card__name">{lastName} {firstName}</div>
              <div className="card__middle-row">{club.name}</div>
              {noResultReason && <div className="card__middle-row">{t(`competitor_${noResultReason}`)}</div>}
              {!noResultReason && (
                <>
                  {europeanShotgunExtraShots && (
                    <div className="card__middle-row">{t('extraRound')}: {europeanShotgunExtraShots.join(', ')}</div>
                  )}
                  <div className="card__middle-row">
                    <MobileSubResult type="shoot" titleKey="european_trap">
                      <ShootingResult score={europeanTrapScore} shots={europeanTrapShots} />
                    </MobileSubResult>
                    <MobileSubResult type="shoot" titleKey="european_compak">
                      <ShootingResult score={europeanCompakScore} shots={europeanCompakShots} />
                    </MobileSubResult>
                  </div>
                </>
              )}
            </div>
            <div className="card__main-value">
              <TotalScore noResultReason={noResultReason} totalScore={europeanShotgunScore} />
            </div>
          </>
        )
      }}
    </MobileResultCards>
  )
}
