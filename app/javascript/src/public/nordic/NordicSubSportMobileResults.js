import React, { useContext } from 'react'
import useTranslation from '../../util/useTranslation'
import { ShowShotsContext } from '../series-results/ResultsWithShots'
import MobileResultCards from '../series-results/MobileResultCards'
import TotalScore from '../series-results/TotalScore'
import MobileSubResult from '../series-results/MobileSubResult'

export default function NordicSubSportMobileResults({ race, competitors }) {
  const { t } = useTranslation()
  const showShots = useContext(ShowShotsContext)
  return (
    <MobileResultCards competitors={competitors}>
      {competitor => {
        const { club, firstName, lastName, nordicExtraShots, nordicScore, nordicShots, noResultReason } = competitor
        return (
          <>
            <div className="card__middle">
              <div className="card__name">{lastName} {firstName}</div>
              <div className="card__middle-row">{club.name}</div>
              {nordicExtraShots && (
                <div className="card__middle-row">{t('extraRound')}: {nordicExtraShots.join(', ')}</div>
              )}
              {showShots && nordicShots && (
                <div className="card__middle-row">
                  <MobileSubResult type="shoot">{nordicShots.join(', ')}</MobileSubResult>
                </div>
              )}
            </div>
            <div className="card__main-value">
              <TotalScore noResultReason={noResultReason} totalScore={nordicScore} />
            </div>
          </>
        )
      }}
    </MobileResultCards>
  )
}
