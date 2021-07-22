export default function CupTotalPoints({ cupCompetitor }) {
  const { points, partialPoints } = cupCompetitor
  if (points) return points
  if (partialPoints) return `(${partialPoints})`
  return '-'
}
