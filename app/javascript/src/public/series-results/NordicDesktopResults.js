import React from 'react'
import useTranslation from '../../util/useTranslation'
import ShootingResult from './ShootingResult'
import { resolveClubTitle } from '../../util/clubUtil'
import NationalRecord from './NationalRecord'
import TotalScore from './TotalScore'
import DesktopResultsRows from './DesktopResultsRows'

export default function NordicDesktopResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors } = series
  const extraShots = !!competitors.find(c => c.nordicExtraScore)
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
        <DesktopResultsRows competitors={competitors}>
          {competitor => {
            const {
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
                <td><ShootingResult score={nordicTrapScore} shots={nordicTrapShots} /></td>
                <td><ShootingResult score={nordicShotgunScore} shots={nordicShotgunShots} /></td>
                <td><ShootingResult score={nordicRifleMovingScore} shots={nordicRifleMovingShots} /></td>
                <td><ShootingResult score={nordicRifleStandingScore} shots={nordicRifleStandingShots} /></td>
                <td className="center total-points">
                  <TotalScore noResultReason={noResultReason} totalScore={nordicScore} />
                  <NationalRecord race={race} series={series} competitor={competitor} />
                </td>
                {extraShots && <td>{nordicExtraScore}</td>}
              </>
            )
          }}
        </DesktopResultsRows>
      </table>
    </div>
  )
}