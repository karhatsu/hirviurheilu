import React from 'react'
import useTranslation from '../../util/useTranslation'
import ShootingResult from './ShootingResult'
import { resolveClubTitle } from '../../util/clubUtil'
import NationalRecord from './NationalRecord'

export default function NordicDesktopResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors } = series
  const extraShots = !!competitors.find(c => c.nordicExtraScore)
  let prevCompetitorPosition = 0
  return (
    <div className="results--desktop">
      <table className="results-table">
        <thead>
          <tr>
            <th />
            <th>{t('name')}</th>
            <th>{t('numberShort')}</th>
            <th>{resolveClubTitle(t, race.clubLevel)}</th>
            <th>{t('nordic_trap')}</th>
            <th>{t('nordic_shotgun')}</th>
            <th>{t('nordic_rifle_standing')}</th>
            <th>{t('nordic_rifle_moving')}</th>
            <th>{t('result')}</th>
            {extraShots && <th>{t('extraRound')}</th>}
          </tr>
        </thead>
        <tbody>
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
              number,
            } = competitor
            const orderNo = position === prevCompetitorPosition ? '' : `${position}.`
            prevCompetitorPosition = position
            const result = noResultReason ? t(`competitor_${noResultReason}`) : nordicScore
            return (
              <tr key={id} className={i % 2 === 0 ? 'odd' : ''}>
                <td>{orderNo}</td>
                <td>{lastName} {firstName}</td>
                <td>{number}</td>
                <td>{club.name}</td>
                <td><ShootingResult score={nordicTrapScore} shots={nordicTrapShots} /></td>
                <td><ShootingResult score={nordicShotgunScore} shots={nordicShotgunShots} /></td>
                <td><ShootingResult score={nordicRifleMovingScore} shots={nordicRifleMovingShots} /></td>
                <td><ShootingResult score={nordicRifleStandingScore} shots={nordicRifleStandingShots} /></td>
                <td className="center total-points">
                  {result || '-'}
                  <NationalRecord race={race} series={series} competitor={competitor} />
                </td>
                {extraShots && <td>{nordicExtraScore}</td>}
              </tr>
            )
          })}
        </tbody>
      </table>
    </div>
  )
}
