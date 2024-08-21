import React, { useContext } from 'react'
import { resolveClubTitle } from '../../util/clubUtil'
import useTranslation from '../../util/useTranslation'
import DesktopResultsRows from '../series-results/DesktopResultsRows'
import ShootingResult from '../series-results/ShootingResult'
import TotalScore from '../series-results/TotalScore'
import { ShowShotsContext } from '../series-results/ResultsWithShots'

export default function EuropeanShotgunDesktopResults({ race, competitors }) {
  const { t } = useTranslation()
  const showShots = useContext(ShowShotsContext)
  const extraShots = !!competitors.find(c => c.europeanShotgunExtraShots)
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
          <th>{t('european_trap')}</th>
          <th>{t('european_compak')}</th>
          <th>{t('result')}</th>
          {extraShots && <th>{t('extraRound')}</th>}
        </tr>
        </thead>
        <DesktopResultsRows competitors={competitors}>
          {competitor => {
            const {
              europeanShotgunExtraShots,
              europeanShotgunScore,
              europeanTrapScore,
              europeanTrapShots,
              europeanCompakScore,
              europeanCompakShots,
              europeanCompakScore2,
              europeanCompakShots2,
              europeanTrapScore2,
              europeanTrapShots2,
              noResultReason,
            } = competitor
            if (noResultReason) {
              return (
                <>
                  <td colSpan={2} />
                  <td className="center total-points"><TotalScore noResultReason={noResultReason} /></td>
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
                <td className="center total-points">
                  <TotalScore
                    noResultReason={noResultReason}
                    totalScore={europeanShotgunScore}
                  />
                </td>
                {extraShots && <td>{europeanShotgunExtraShots?.join(', ')}</td>}
              </>
            )
          }}
        </DesktopResultsRows>
      </table>
    </div>
  )
}
