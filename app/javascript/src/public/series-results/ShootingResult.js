import { useContext } from 'react'
import { ShowShotsContext } from './ResultsWithShots'

export default function ShootingResult({ score, shots }) {
  const showShots = useContext(ShowShotsContext)
  return showShots && shots ? `${score} (${shots.map(s => s === 11 ? '10*' : s).join(', ')})` : score
}
