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
          europeanShotgunExtraScore,
          europeanShotgunScore,
          europeanTrapScore,
          europeanTrapShots,
          europeanCompakScore,
          europeanCompakShots,
          europeanCompakScore2,
          europeanCompakShots2,
          europeanTrapScore2,
          europeanTrapShots2,
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
                  {europeanShotgunExtraScore && (
                    <div className="card__middle-row">{t('extraRound')}: {europeanShotgunExtraScore}</div>
                  )}
                  <div className="card__middle-row">
                    <MobileSubResult type="shoot" titleKey="european_trap">
                      <ShootingResult
                        score={europeanTrapScore}
                        shots={europeanTrapShots}
                        score2={europeanTrapScore2}
                        shots2={europeanTrapShots2}
                      />
                    </MobileSubResult>
                    <MobileSubResult type="shoot" titleKey="european_compak">
                      <ShootingResult
                        score={europeanCompakScore}
                        shots={europeanCompakShots}
                        score2={europeanCompakScore2}
                        shots2={europeanCompakShots2}
                      />
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
