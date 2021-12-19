import React from 'react'
import ShootingResult from './ShootingResult'
import QualificationRoundShootingResult from './QualificationRoundShootingResult'

export default function QualificationRoundDesktopShootingResult({ competitor }) {
  const {
    qualificationRoundScore,
    qualificationRoundShots,
    qualificationRoundSubScores,
  } = competitor
  if (qualificationRoundShots && qualificationRoundSubScores.length >= 2) {
    return <QualificationRoundShootingResult competitor={competitor} />
  }
  return <ShootingResult score={qualificationRoundScore} shots={qualificationRoundShots} />
}
