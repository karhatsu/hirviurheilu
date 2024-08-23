import React from 'react'
import useTranslation from '../../util/useTranslation'
import MobileResultCards from '../series-results/MobileResultCards'
import MobileSubResult from '../series-results/MobileSubResult'
import ShootingResult from '../series-results/ShootingResult'
import TotalScore from '../series-results/TotalScore'
import EuropeanRifleNationalRecord from './EuropeanRifleNationalRecord'

export default function EuropeanRifleMobileResults({ race, series, competitors }) {
  const { t } = useTranslation()
  return (
    <MobileResultCards competitors={competitors}>
      {competitor => {
        const {
          club,
          europeanRifleExtraScore,
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
          europeanRifle1Score2,
          europeanRifle1Shots2,
          europeanRifle2Score2,
          europeanRifle2Shots2,
          europeanRifle3Score2,
          europeanRifle3Shots2,
          europeanRifle4Score2,
          europeanRifle4Shots2,
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
                  {europeanRifleExtraShots && (
                    <div className="card__middle-row">
                      <MobileSubResult type="shoot" titleKey="extraRound">
                        <ShootingResult score={europeanRifleExtraScore} shots={europeanRifleExtraShots} />
                      </MobileSubResult>
                    </div>
                  )}
                  <div className="card__middle-row">
                    <MobileSubResult type="shoot" titleKey="european_rifle1">
                      <ShootingResult
                        score={europeanRifle1Score}
                        shots={europeanRifle1Shots}
                        score2={europeanRifle1Score2}
                        shots2={europeanRifle1Shots2}
                      />
                    </MobileSubResult>
                    <MobileSubResult type="shoot" titleKey="european_rifle2">
                      <ShootingResult
                        score={europeanRifle2Score}
                        shots={europeanRifle2Shots}
                        score2={europeanRifle2Score2}
                        shots2={europeanRifle2Shots2}
                      />
                    </MobileSubResult>
                    <MobileSubResult type="shoot" titleKey="european_rifle3">
                      <ShootingResult
                        score={europeanRifle3Score}
                        shots={europeanRifle3Shots}
                        score2={europeanRifle3Score2}
                        shots2={europeanRifle3Shots2}
                      />
                    </MobileSubResult>
                    <MobileSubResult type="shoot" titleKey="european_rifle4">
                      <ShootingResult
                        score={europeanRifle4Score}
                        shots={europeanRifle4Shots}
                        score2={europeanRifle4Score2}
                        shots2={europeanRifle4Shots2}
                      />
                    </MobileSubResult>
                  </div>
                </>
              )}
            </div>
            <div className="card__main-value">
              <TotalScore noResultReason={noResultReason} totalScore={europeanRifleScore} />
              {series && <EuropeanRifleNationalRecord race={race} series={series} competitor={competitor} />}
            </div>
          </>
        )
      }}
    </MobileResultCards>
  )
}
