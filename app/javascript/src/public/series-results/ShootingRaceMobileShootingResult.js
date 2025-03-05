import ShootingResult from './ShootingResult'
import useTranslation from '../../util/useTranslation'
import QualificationRoundShootingResult from './QualificationRoundShootingResult'

export default function ShootingRaceMobileShootingResult({ competitor }) {
  const { t } = useTranslation()
  const {
    qualificationRoundScore,
    qualificationRoundShots,
    qualificationRoundSubScores,
    finalRoundScore,
    finalRoundShots,
    finalRoundTotalScore,
    noResultReason,
    shootingRulesPenalty,
    shootingRulesPenaltyQr,
  } = competitor
  if (noResultReason) {
    return <div className="card__middle-row">{t(`competitor_${noResultReason}`)}</div>
  }
  if (qualificationRoundShots && qualificationRoundSubScores.length >= 2) {
    return (
      <>
        <div className="card__middle-row">
          <QualificationRoundShootingResult competitor={competitor} />
        </div>
        {finalRoundShots && finalRoundShots[0].length > 0 && (
          <div className="card__middle-row">
            <ShootingResult score={finalRoundScore} shots={finalRoundShots[0]} />
            {shootingRulesPenalty && ` - ${shootingRulesPenalty} = ${finalRoundTotalScore}`}
          </div>
        )}
      </>
    )
  }
  return (
    <div className="card__middle-row">
      <ShootingResult score={qualificationRoundScore} shots={qualificationRoundShots && qualificationRoundShots[0]} />
      {shootingRulesPenaltyQr && ` - ${shootingRulesPenaltyQr}`}
      {(finalRoundScore !== null) && (
        <>
          {' + '}<ShootingResult score={finalRoundScore} shots={finalRoundShots && finalRoundShots[0]} />
        </>
      )}
      {shootingRulesPenalty && ` - ${shootingRulesPenalty}`}
    </div>
  )
}
