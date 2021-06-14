import React, { useContext } from 'react'
import DesktopResultsRows from '../series-results/DesktopResultsRows'
import { resolveClubTitle } from '../../util/clubUtil'
import useTranslation from '../../util/useTranslation'
import { ShowShotsContext } from '../series-results/ResultsWithShots'
import TotalScore from '../series-results/TotalScore'

export default function NordicSubSportDesktopResults({ race, competitors }) {
  const { t } = useTranslation()
  const showShots = useContext(ShowShotsContext)
  const extraShots = !!competitors.find(c => c.nordicExtraShots)
  return (
    <div className="results--desktop">
      <table className="results-table">
        <thead>
          <tr>
            <th />
            <th>{t('name')}</th>
            <th>{t('numberShort')}</th>
            <th>{resolveClubTitle(t, race.clubLevel)}</th>
            <th>{t('series')}</th>
            {showShots && <th>{t('shots')}</th>}
            <th>{t('result')}</th>
            {extraShots && <th>{t('extraRound')}</th>}
          </tr>
        </thead>
        <DesktopResultsRows competitors={competitors}>
          {competitor => {
            const { nordicExtraShots, nordicScore, nordicShots, noResultReason, series } = competitor
            return (
              <>
                <td>{series.name}</td>
                {showShots && <td>{nordicShots.join(', ')}</td>}
                <td className="center total-points">
                  <TotalScore totalScore={nordicScore} noResultReason={noResultReason} />
                </td>
                {extraShots && <td>{nordicExtraShots?.join(', ')}</td>}
              </>
            )
          }}
        </DesktopResultsRows>
      </table>
    </div>
  )
}
