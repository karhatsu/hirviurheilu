import React from 'react'
import useTranslation from '../../util/useTranslation'
import MobileSubResult from './MobileSubResult'
import ShootingResult from './ShootingResult'
import NationalRecord from './NationalRecord'
import TotalScore from './TotalScore'
import MobileResultCards from './MobileResultCards'

export default function NordicMobileResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors } = series
  return (
    <MobileResultCards competitors={competitors}>
      {competitor => {
        const {
          club,
          firstName,
          lastName,
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
        return (
          <>
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
              <TotalScore noResultReason={noResultReason} totalScore={nordicScore} />
              <NationalRecord race={race} series={series} competitor={competitor} />
            </div>
          </>
        )
      }}
    </MobileResultCards>
  )
}
