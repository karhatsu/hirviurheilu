export default function ShootingPoints({ competitor }) {
  const {
    noResultReason,
    shootingScore,
    shootingPoints,
    shootingOvertimePenalty,
    shootingRulesPenalty,
    shots,
  } = competitor
  if (noResultReason) return ''
  if (!shootingScore) return '-'
  const scoreMinusPenalties = `${shootingScore}${-shootingOvertimePenalty || ''}${-shootingRulesPenalty || ''}`
  if (!shots) return `${shootingPoints} (${scoreMinusPenalties})`
  return `${shootingPoints} (${scoreMinusPenalties} / ${shots.join(', ')})`
}
