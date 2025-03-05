import { Fragment } from 'react'
import ShootingResult from './ShootingResult'

export default function QualificationRoundShootingResult({ competitor }) {
  const {
    qualificationRoundShots,
    qualificationRoundSubScores,
    qualificationRoundTotalScore,
    shootingRulesPenaltyQr,
  } = competitor
  if (!qualificationRoundShots) return null
  return (
    <>
      {qualificationRoundShots.map((shots, i) => {
        if (i === 0) {
          return <ShootingResult key={i} score={qualificationRoundSubScores[0]} shots={qualificationRoundShots[0]} />
        } else if (qualificationRoundShots[i].length > 0) {
          return (
            <Fragment key={i}>
              {' + '}<ShootingResult score={qualificationRoundSubScores[i]} shots={qualificationRoundShots[i]} />
            </Fragment>
          )
        }
        return null
      })}
      {shootingRulesPenaltyQr && ` - ${shootingRulesPenaltyQr}`}
      {qualificationRoundSubScores.length >= 2 && qualificationRoundShots[1].length > 0 && (
        <>
          {' = '}{qualificationRoundTotalScore}
        </>
      )}
    </>
  )
}
