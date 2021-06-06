import React from 'react'
import ShootingResult from './ShootingResult'

export default function ShootingRaceMobileShootingResult({ competitor }) {
  const {
    qualificationRoundScore,
    qualificationRoundShots,
    qualificationRoundSubScores,
    finalRoundScore,
    finalRoundShots,
  } = competitor
  if (qualificationRoundShots && qualificationRoundSubScores.length === 2) {
    return (
      <>
        <ShootingResult score={qualificationRoundSubScores[0]} shots={qualificationRoundShots[0]} />
        {qualificationRoundShots[1] && (
          <>
            {' + '}<ShootingResult score={qualificationRoundSubScores[1]} shots={qualificationRoundShots[1]} />
            {' = '}{qualificationRoundScore}
          </>
        )}
        {finalRoundShots && (
          <div className="card__middle-row">
            <ShootingResult score={finalRoundScore} shots={finalRoundShots[0]} />
          </div>
        )}
      </>
    )
  }
  return (
    <>
      <ShootingResult score={qualificationRoundScore} shots={qualificationRoundShots && qualificationRoundShots[0]} />
      {finalRoundScore && (
        <>
          {' + '}<ShootingResult score={finalRoundScore} shots={finalRoundShots && finalRoundShots[0]} />
        </>
      )}
    </>
  )
}
