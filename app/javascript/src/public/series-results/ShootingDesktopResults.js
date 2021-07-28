import React, { useContext } from 'react'
import useTranslation from '../../util/useTranslation'
import { resolveClubTitle } from '../../util/clubUtil'
import NationalRecord from './NationalRecord'
import ShootingResult from './ShootingResult'
import QualificationRoundDesktopShootingResult from './QualificationRoundDesktopShootingResult'
import TotalScore from './TotalScore'
import DesktopResultsRows from './DesktopResultsRows'
import { ShowShotsContext } from './ResultsWithShots'

export default function ShootingDesktopResults({ race, series }) {
  const { t } = useTranslation()
  const showShots = useContext(ShowShotsContext)
  const { competitors } = series
  const showExtraShots = !!competitors.find(c => c.extraShots)
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
            <th>{t('qualificationRound')}</th>
            <th>{t('finalRound')}</th>
            <th>{t('result')}</th>
            {showExtraShots && <th>{t('extraRound')}</th>}
          </tr>
        </thead>
        <DesktopResultsRows competitors={competitors}>
          {competitor => {
            const {
              extraScore,
              extraShots,
              finalRoundScore,
              finalRoundShots,
              noResultReason,
              shootingScore,
            } = competitor
            if (noResultReason) {
              return (
                <>
                  <td colSpan={2} />
                  <td className="center total-points"><TotalScore noResultReason={noResultReason} /></td>
                  {showExtraShots && <td />}
                </>
              )
            }
            return (
              <>
                <td className={resultClassName}>
                  <QualificationRoundDesktopShootingResult competitor={competitor} />
                </td>
                <td className={resultClassName}>
                  <ShootingResult score={finalRoundScore} shots={finalRoundShots && finalRoundShots[0]} />
                </td>
                <td className="center total-points">
                  <TotalScore noResultReason={noResultReason} totalScore={shootingScore} />
                  <NationalRecord race={race} series={series} competitor={competitor} />
                </td>
                {showExtraShots && (
                  <td className={resultClassName}>
                    {extraShots && <ShootingResult score={extraScore} shots={extraShots} />}
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
