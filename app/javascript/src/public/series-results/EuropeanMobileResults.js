import React from 'react'
import useTranslation from '../../util/useTranslation'
import MobileSubResult from './MobileSubResult'
import ShootingResult from './ShootingResult'
import NationalRecord from './NationalRecord'
import TotalScore from './TotalScore'

export default function EuropeanMobileResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors } = series
  let prevCompetitorPosition = 0
  return (
    <div className="results--mobile result-cards">
      {competitors.map((competitor, i) => {
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
          id,
          lastName,
          position,
          noResultReason,
        } = competitor
        const orderNo = position === prevCompetitorPosition ? '' : `${position}.`
        prevCompetitorPosition = position
        return (
          <div key={id} className={`card ${i % 2 === 0 ? 'card--odd' : ''}`}>
            <div className="card__number">{orderNo}</div>
            <div className="card__middle">
              <div className="card__name">{lastName} {firstName}</div>
              <div className="card__middle-row">{club.name}</div>
              {europeanExtraScore && <div className="card__middle-row">{t('extraRound')}: {europeanExtraScore}</div>}
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
            </div>
            <div className="card__main-value">
              <TotalScore noResultReason={noResultReason} totalScore={europeanScore} />
              <NationalRecord race={race} series={series} competitor={competitor} />
            </div>
          </div>
        )
      })}
    </div>
  )
}
