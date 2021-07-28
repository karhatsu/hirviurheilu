import React from 'react'
import useTranslation from '../../util/useTranslation'
import MobileSubResult from './MobileSubResult'
import ShootingResult from './ShootingResult'
import NationalRecord from './NationalRecord'
import TotalScore from './TotalScore'
import MobileResultCards from './MobileResultCards'

export default function EuropeanMobileResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors } = series
  return (
    <MobileResultCards competitors={competitors}>
      {competitor => {
        const {
          club,
          europeanExtraScore,
          europeanScore,
          europeanRifle1Score,
          europeanRifle1Shots,
          europeanRifle2Score,
          europeanRifle2Shots,
          europeanRifle3Score,
          europeanRifle3Shots,
          europeanRifle4Score,
          europeanRifle4Shots,
          europeanCompakScore,
          europeanCompakShots,
          europeanTrapScore,
          europeanTrapShots,
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
                  {europeanExtraScore && (
                    <div className="card__middle-row">{t('extraRound')}: {europeanExtraScore}</div>
                  )}
                  <div className="card__middle-row">
                    <MobileSubResult type="shoot" titleKey="european_trap">
                      <ShootingResult score={europeanTrapScore} shots={europeanTrapShots} />
                    </MobileSubResult>
                    <MobileSubResult type="shoot" titleKey="european_compak">
                      <ShootingResult score={europeanCompakScore} shots={europeanCompakShots} />
                    </MobileSubResult>
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
                </>
              )}
            </div>
            <div className="card__main-value">
              <TotalScore noResultReason={noResultReason} totalScore={europeanScore} />
              <NationalRecord race={race} series={series} competitor={competitor} />
            </div>
          </>
        )
      }}
    </MobileResultCards>
  )
}
