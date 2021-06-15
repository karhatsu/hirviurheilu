import React from 'react'
import useTranslation from '../../util/useTranslation'
import MobileResultCards from '../series-results/MobileResultCards'
import MobileSubResult from '../series-results/MobileSubResult'
import ShootingResult from '../series-results/ShootingResult'
import TotalScore from '../series-results/TotalScore'
import EuropeanRifleNationalRecord from './EuropeanRifleNationalRecord'

export default function EuropeanRifleMobileResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors } = series
  return (
    <MobileResultCards competitors={competitors}>
      {competitor => {
        const {
          club,
          europeanRifleExtraShots,
          europeanRifleScore,
          europeanRifle1Score,
          europeanRifle1Shots,
          europeanRifle2Score,
          europeanRifle2Shots,
          europeanRifle3Score,
          europeanRifle3Shots,
          europeanRifle4Score,
          europeanRifle4Shots,
          firstName,
          lastName,
          noResultReason,
        } = competitor
        return (
          <>
            <div className="card__middle">
              <div className="card__name">{lastName} {firstName}</div>
              <div className="card__middle-row">{club.name}</div>
              {europeanRifleExtraShots && (
                <div className="card__middle-row">{t('extraRound')}: {europeanRifleExtraShots.join(', ')}</div>
              )}
              <div className="card__middle-row">
                <MobileSubResult type="shoot" titleKey="european_rifle1">
                  <ShootingResult score={europeanRifle1Score} shots={europeanRifle1Shots} />
                </MobileSubResult>
                <MobileSubResult type="shoot" titleKey="european_rifle2">
                  <ShootingResult score={europeanRifle2Score} shots={europeanRifle2Shots} />
                </MobileSubResult>
                <MobileSubResult type="shoot" titleKey="european_rifle3">
                  <ShootingResult score={europeanRifle3Score} shots={europeanRifle3Shots} />
                </MobileSubResult>
                <MobileSubResult type="shoot" titleKey="european_rifle4">
                  <ShootingResult score={europeanRifle4Score} shots={europeanRifle4Shots} />
                </MobileSubResult>
              </div>
            </div>
            <div className="card__main-value">
              <TotalScore noResultReason={noResultReason} totalScore={europeanRifleScore} />
              <EuropeanRifleNationalRecord race={race} series={series} competitor={competitor} />
            </div>
          </>
        )
      }}
    </MobileResultCards>
  )
}
