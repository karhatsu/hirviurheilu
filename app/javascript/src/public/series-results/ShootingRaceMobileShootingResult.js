import React from 'react'
import ShootingResult from './ShootingResult'
import useTranslation from '../../util/useTranslation'

export default function ShootingRaceMobileShootingResult({ competitor }) {
  const { t } = useTranslation()
  const {
    qualificationRoundScore,
    qualificationRoundShots,
    qualificationRoundSubScores,
    finalRoundScore,
    finalRoundShots,
    noResultReason,
  } = competitor
  if (noResultReason) {
    return <div className="card__middle-row">{t(`competitor_${noResultReason}`)}</div>
  }
  if (qualificationRoundShots && qualificationRoundSubScores.length === 2) {
    return (
      <>
        <div className="card__middle-row">
          <ShootingResult score={qualificationRoundSubScores[0]} shots={qualificationRoundShots[0]} />
          {qualificationRoundShots[1] && qualificationRoundShots[1].length > 0 && (
            <>
              {' + '}<ShootingResult score={qualificationRoundSubScores[1]} shots={qualificationRoundShots[1]} />
              {' = '}{qualificationRoundScore}
            </>
          )}
        </div>
        {finalRoundShots && finalRoundShots[0].length > 0 && (
          <div className="card__middle-row">
            <ShootingResult score={finalRoundScore} shots={finalRoundShots[0]} />
          </div>
        )}
      </>
    )
  }
  return (
    <div className="card__middle-row">
      <ShootingResult score={qualificationRoundScore} shots={qualificationRoundShots && qualificationRoundShots[0]} />
      {(finalRoundScore !== null) && (
        <>
          {' + '}<ShootingResult score={finalRoundScore} shots={finalRoundShots && finalRoundShots[0]} />
        </>
      )}
    </div>
  )
}
