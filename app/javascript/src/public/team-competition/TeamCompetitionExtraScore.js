export default function TeamCompetitionExtraScore({ team }) {
  const { extraScore, extraShots, worseExtraShots } = team
  if (extraShots.length) {
    const bestShots = extraShots.join(', ')
    if (worseExtraShots.length) {
      return `${bestShots} (${worseExtraShots.join(', ')})`
    }
    return bestShots
  } else if (extraScore.length) {
    return extraScore.join(', ')
  } else {
    return null
  }
}
