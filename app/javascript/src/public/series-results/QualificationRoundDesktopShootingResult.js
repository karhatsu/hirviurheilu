import React from 'react'
import ShootingResult from './ShootingResult'

export default function QualificationRoundDesktopShootingResult({ competitor }) {
  const {
    qualificationRoundScore,
    qualificationRoundShots,
    qualificationRoundSubScores,
  } = competitor
  if (qualificationRoundShots && qualificationRoundSubScores.length === 2) {
    return (
      <>
        <ShootingResult score={qualificationRoundSubScores[0]} shots={qualificationRoundShots[0]} />
        {qualificationRoundShots[1].length > 0 && (
          <>
            {' + '}<ShootingResult score={qualificationRoundSubScores[1]} shots={qualificationRoundShots[1]} />
            {' = '}{qualificationRoundScore}
          </>
        )}
      </>
    )
  }
  return <ShootingResult score={qualificationRoundScore} shots={qualificationRoundShots} />
}
