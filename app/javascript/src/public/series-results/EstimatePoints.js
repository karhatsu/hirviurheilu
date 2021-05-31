const estimateDiffs = (competitor, series) => {
  const { estimates, correctDistances } = competitor
  return estimates.map((estimate, i) => {
    if (!correctDistances[i]) return undefined
    const diff = estimate - correctDistances[i]
    return diff > 0 ? `+${diff}m` : `${diff}m`
  }).filter(e => e).splice(0, series.estimates).join('/')
}

export default function EstimatePoints({ competitor, race, series }) {
  const { estimatePoints, noResultReason } = competitor
  if (noResultReason) {
    return ''
  } else if (!estimatePoints) {
    return '-'
  } else if (race.showCorrectDistances) {
    return `${estimatePoints} (${estimateDiffs(competitor, series)})`
  } else {
    return estimatePoints
  }
}
