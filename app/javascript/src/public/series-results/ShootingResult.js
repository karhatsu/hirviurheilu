import { useContext } from 'react'
import { ShowShotsContext } from './ResultsWithShots'

export default function ShootingResult({ score, shots }) {
  const showShots = useContext(ShowShotsContext)
  return showShots && shots ? `${score} (${shots.join(', ')})` : score
}
