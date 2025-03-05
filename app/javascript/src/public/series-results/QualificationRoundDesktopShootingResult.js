import ShootingResult from './ShootingResult'
import QualificationRoundShootingResult from './QualificationRoundShootingResult'

export default function QualificationRoundDesktopShootingResult({ competitor }) {
  const {
    shootingRulesPenaltyQr,
    qualificationRoundScore,
    qualificationRoundShots,
    qualificationRoundSubScores,
    qualificationRoundTotalScore,
  } = competitor
  if (qualificationRoundShots && qualificationRoundSubScores.length >= 2) {
    return <QualificationRoundShootingResult competitor={competitor} />
  }
  return (
    <>
      <ShootingResult score={qualificationRoundScore} shots={qualificationRoundShots} />
      {shootingRulesPenaltyQr && ` - ${shootingRulesPenaltyQr} = ${qualificationRoundTotalScore}`}
    </>
  )
}
