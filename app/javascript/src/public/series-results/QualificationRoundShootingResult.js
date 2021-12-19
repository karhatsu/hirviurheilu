import React from 'react'
import ShootingResult from './ShootingResult'

export default function QualificationRoundShootingResult({ competitor }) {
  const { qualificationRoundShots, qualificationRoundSubScores, qualificationRoundScore } = competitor
  if (!qualificationRoundShots) return null
  return (
    <>
      {qualificationRoundShots.map((shots, i) => {
        if (i === 0) {
          return <ShootingResult key={i} score={qualificationRoundSubScores[0]} shots={qualificationRoundShots[0]} />
        } else if (qualificationRoundShots[i].length > 0) {
          return (
            <React.Fragment key={i}>
              {' + '}<ShootingResult score={qualificationRoundSubScores[i]} shots={qualificationRoundShots[i]} />
            </React.Fragment>
          )
        }
        return null
      })}
      {qualificationRoundSubScores.length >= 2 && qualificationRoundShots[1].length > 0 && (
        <>
          {' = '}{qualificationRoundScore}
        </>
      )}
    </>
  )
}
