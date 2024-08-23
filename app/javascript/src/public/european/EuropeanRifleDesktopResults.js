import React, { useContext } from 'react'
import { resolveClubTitle } from '../../util/clubUtil'
import useTranslation from '../../util/useTranslation'
import DesktopResultsRows from '../series-results/DesktopResultsRows'
import ShootingResult from '../series-results/ShootingResult'
import TotalScore from '../series-results/TotalScore'
import EuropeanRifleNationalRecord from './EuropeanRifleNationalRecord'
import { ShowShotsContext } from '../series-results/ResultsWithShots'

export default function EuropeanRifleDesktopResults({ race, series, competitors }) {
  const { t } = useTranslation()
  const showShots = useContext(ShowShotsContext)
  const extraShots = !!competitors.find(c => c.europeanRifleExtraShots)
  const resultClassName = showShots ? '' : 'center'
  return (
    <div className="results--desktop">
      <table className="results-table">
        <thead>
        <tr>
          <th />
          <th>{t('name')}</th>
          <th>{t('numberShort')}</th>
          <th>{resolveClubTitle(t, race.clubLevel)}</th>
          <th>{t('european_rifle1')}</th>
          <th>{t('european_rifle2')}</th>
          <th>{t('european_rifle3')}</th>
          <th>{t('european_rifle4')}</th>
          <th>{t('result')}</th>
          {extraShots && <th>{t('extraRound')}</th>}
        </tr>
        </thead>
        <DesktopResultsRows competitors={competitors}>
          {competitor => {
            const {
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
              noResultReason,
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
                  <TotalScore noResultReason={noResultReason} totalScore={europeanRifleScore}/>
                  {series && <EuropeanRifleNationalRecord race={race} series={series} competitor={competitor}/>}
                </td>
                {extraShots && (
                  <td>
                    <ShootingResult score={europeanRifleExtraScore} shots={europeanRifleExtraShots} />
                  </td>
                )}
              </>
            )
          }}
        </DesktopResultsRows>
      </table>
    </div>
  )
}
