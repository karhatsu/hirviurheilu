import { useContext, useEffect } from 'react'
import useTranslation from '../../util/useTranslation'
import ShootingResult from './ShootingResult'
import { resolveClubTitle } from '../../util/clubUtil'
import NationalRecord from './NationalRecord'
import TotalScore from './TotalScore'
import DesktopResultsRows from './DesktopResultsRows'
import { ShowShotsContext } from './ResultsWithShots'
import { useResultRotation } from "../result-rotation/useResultRotation"

export default function NordicDesktopResults({ race, series }) {
  const { t } = useTranslation()
  const showShots = useContext(ShowShotsContext)
  const { competitors } = series
  const extraShots = !!competitors.find(c => c.nordicExtraScore)
  const resultClassName = showShots ? '' : 'center'
  const { scrollAutomatically } = useResultRotation()

  useEffect(() => scrollAutomatically(), [scrollAutomatically])

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
            <th>{t('nordic_rifle_moving')}</th>
            <th>{t('nordic_rifle_standing')}</th>
            <th>{t('result')}</th>
            {extraShots && <th>{t('extraRound')}</th>}
          </tr>
        </thead>
        <DesktopResultsRows competitors={competitors}>
          {competitor => {
            const {
              nordicExtraScore,
              nordicRifleMovingScore,
              nordicRifleMovingShots,
              nordicRifleStandingScore,
              nordicRifleStandingShots,
              nordicShotgunScore,
              nordicShotgunShots,
              nordicTrapScore,
              nordicTrapShots,
              noResultReason,
              shootingRulesPenalty,
              totalScore,
            } = competitor
            if (noResultReason) {
              return (
                <>
                  <td colSpan={4} />
                  <td className="center total-points"><TotalScore noResultReason={noResultReason} /></td>
                  {extraShots && <td />}
                </>
              )
            }
            return (
              <>
                <td className={resultClassName}>
                  <ShootingResult score={nordicTrapScore} shots={nordicTrapShots} />
                </td>
                <td className={resultClassName}>
                  <ShootingResult score={nordicShotgunScore} shots={nordicShotgunShots} />
                </td>
                <td className={resultClassName}>
                  <ShootingResult score={nordicRifleMovingScore} shots={nordicRifleMovingShots} />
                </td>
                <td className={resultClassName}>
                  <ShootingResult score={nordicRifleStandingScore} shots={nordicRifleStandingShots} />
                </td>
                <td className="center total-points">
                  <TotalScore noResultReason={noResultReason} totalScore={totalScore} penalty={shootingRulesPenalty} />
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
