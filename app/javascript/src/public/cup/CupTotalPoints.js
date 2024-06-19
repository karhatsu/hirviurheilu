export default function CupTotalPoints({ cupCompetitor }) {
  const { score, partialScore } = cupCompetitor
  if (score) return score
  if (partialScore) return `(${partialScore})`
  return '-'
}
