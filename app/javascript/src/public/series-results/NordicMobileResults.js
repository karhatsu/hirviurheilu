import React from 'react'
import useTranslation from '../../util/useTranslation'
import MobileSubResult from './MobileSubResult'
import ShootingResult from './ShootingResult'
import NationalRecord from './NationalRecord'

export default function NordicMobileResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors } = series
  let prevCompetitorPosition = 0
  return (
    <div className="results--mobile result-cards">
      {competitors.map((competitor, i) => {
        const {
          club,
          firstName,
          id,
          lastName,
          position,
          nordicExtraScore,
          nordicScore,
          nordicRifleMovingScore,
          nordicRifleMovingShots,
          nordicRifleStandingScore,
          nordicRifleStandingShots,
          nordicShotgunScore,
          nordicShotgunShots,
          nordicTrapScore,
          nordicTrapShots,
          noResultReason,
        } = competitor
        const orderNo = position === prevCompetitorPosition ? '' : `${position}.`
        prevCompetitorPosition = position
        const result = noResultReason ? t(`competitor_${noResultReason}`) : nordicScore
        return (
          <div key={id} className={`card ${i % 2 === 0 ? 'card--odd' : ''}`}>
            <div className="card__number">{orderNo}</div>
            <div className="card__middle">
              <div className="card__name">{lastName} {firstName}</div>
              <div className="card__middle-row">{club.name}</div>
              {nordicExtraScore && <div className="card__middle-row">{t('extraRound')}: {nordicExtraScore}</div>}
              <div className="card__middle-row">
                <MobileSubResult type="shoot" titleKey="nordic_trap">
                  <ShootingResult score={nordicTrapScore} shots={nordicTrapShots} />
                </MobileSubResult>
                <MobileSubResult type="shoot" titleKey="nordic_shotgun">
                  <ShootingResult score={nordicShotgunScore} shots={nordicShotgunShots} />
                </MobileSubResult>
                <MobileSubResult type="shoot" titleKey="nordic_rifle_moving">
                  <ShootingResult score={nordicRifleMovingScore} shots={nordicRifleMovingShots} />
                </MobileSubResult>
                <MobileSubResult type="shoot" titleKey="nordic_rifle_standing">
                  <ShootingResult score={nordicRifleStandingScore} shots={nordicRifleStandingShots} />
                </MobileSubResult>
              </div>
            </div>
            <div className="card__main-value">
              {result}
              <NationalRecord race={race} series={series} competitor={competitor} />
            </div>
          </div>
        )
      })}
    </div>
  )
}
