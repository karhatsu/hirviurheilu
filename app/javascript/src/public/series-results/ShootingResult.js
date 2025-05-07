import { useContext } from 'react'
import { ShowShotsContext } from './ResultsWithShots'

const formatShots = (shots) => shots.map((s) => (s === 11 ? '10⊙' : s)).join(', ')

export default function ShootingResult({ score, shots, score2, shots2 }) {
  const showShots = useContext(ShowShotsContext)
  if (showShots && shots && shots2) {
    return `${score} (${formatShots(shots)}) + ${score2} (${formatShots(shots2)})`
  } else if (showShots && shots) {
    return `${score} (${formatShots(shots)})`
  } else if (score && score2) {
    return `${score} + ${score2}`
  } else {
    return score
  }
}
