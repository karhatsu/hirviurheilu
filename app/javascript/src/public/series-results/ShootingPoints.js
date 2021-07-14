export default function ShootingPoints({ competitor }) {
  const { noResultReason, shootingScore, shootingPoints, shootingOvertimePenalty, shots } = competitor
  if (noResultReason) return ''
  if (!shootingScore) return '-'
  if (!shots) return `${shootingPoints} (${shootingScore})`
  return `${shootingPoints} (${shootingScore}${shootingOvertimePenalty || ''} / ${shots.join(', ')})`
}
