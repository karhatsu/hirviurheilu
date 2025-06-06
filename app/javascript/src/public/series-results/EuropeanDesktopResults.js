import { useContext, useEffect } from 'react'
import useTranslation from '../../util/useTranslation'
import ShootingResult from './ShootingResult'
import { resolveClubTitle } from '../../util/clubUtil'
import NationalRecord from './NationalRecord'
import TotalScore from './TotalScore'
import DesktopResultsRows from './DesktopResultsRows'
import { ShowShotsContext } from './ResultsWithShots'
import { useResultRotation } from '../result-rotation/useResultRotation'

export default function EuropeanDesktopResults({ race, series }) {
  const { t } = useTranslation()
  const showShots = useContext(ShowShotsContext)
  const { competitors } = series
  const extraShots = !!competitors.find((c) => c.europeanExtraScore)
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
            <th>{t('european_trap')}</th>
            <th>{t('european_compak')}</th>
            <th>{t('european_rifle1')}</th>
            <th>{t('european_rifle2')}</th>
            <th>{t('european_rifle3')}</th>
            <th>{t('european_rifle4')}</th>
            <th>{t('result')}</th>
            {extraShots && <th>{t('extraRound')}</th>}
          </tr>
        </thead>
        <DesktopResultsRows competitors={competitors}>
          {(competitor) => {
            const {
              europeanExtraScore,
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
              europeanRifle1Score2,
              europeanRifle1Shots2,
              europeanRifle2Score2,
              europeanRifle2Shots2,
              europeanRifle3Score2,
              europeanRifle3Shots2,
              europeanRifle4Score2,
              europeanRifle4Shots2,
              europeanCompakScore2,
              europeanCompakShots2,
              europeanTrapScore2,
              europeanTrapShots2,
              noResultReason,
              shootingRulesPenalty,
              totalScore,
            } = competitor
            if (noResultReason) {
              return (
                <>
                  <td colSpan={6} />
                  <td className="center total-points">
                    <TotalScore noResultReason={noResultReason} />
                  </td>
                  {extraShots && <td />}
                </>
              )
            }
            return (
              <>
                <td className={resultClassName}>
                  <ShootingResult
                    score={europeanTrapScore}
                    shots={europeanTrapShots}
                    score2={europeanTrapScore2}
                    shots2={europeanTrapShots2}
                  />
                </td>
                <td className={resultClassName}>
                  <ShootingResult
                    score={europeanCompakScore}
                    shots={europeanCompakShots}
                    score2={europeanCompakScore2}
                    shots2={europeanCompakShots2}
                  />
                </td>
                <td className={resultClassName}>
                  <ShootingResult
                    score={europeanRifle1Score}
                    shots={europeanRifle1Shots}
                    score2={europeanRifle1Score2}
                    shots2={europeanRifle1Shots2}
                  />
                </td>
                <td className={resultClassName}>
                  <ShootingResult
                    score={europeanRifle2Score}
                    shots={europeanRifle2Shots}
                    score2={europeanRifle2Score2}
                    shots2={europeanRifle2Shots2}
                  />
                </td>
                <td className={resultClassName}>
                  <ShootingResult
                    score={europeanRifle3Score}
                    shots={europeanRifle3Shots}
                    score2={europeanRifle3Score2}
                    shots2={europeanRifle3Shots2}
                  />
                </td>
                <td className={resultClassName}>
                  <ShootingResult
                    score={europeanRifle4Score}
                    shots={europeanRifle4Shots}
                    score2={europeanRifle4Score2}
                    shots2={europeanRifle4Shots2}
                  />
                </td>
                <td className="center total-points">
                  <TotalScore noResultReason={noResultReason} totalScore={totalScore} penalty={shootingRulesPenalty} />
                  <NationalRecord race={race} series={series} competitor={competitor} />
                </td>
                {extraShots && <td>{europeanExtraScore}</td>}
              </>
            )
          }}
        </DesktopResultsRows>
      </table>
    </div>
  )
}
