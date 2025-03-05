import NoResultReason from '../NoResultReason'

export default function Points({ competitor }) {
  const { finished, hasCorrectEstimates, noResultReason, totalScore } = competitor
  if (noResultReason) {
    return <NoResultReason noResultReason={noResultReason} type="competitor" />
  } else if (!totalScore) {
    return '-'
  } else {
    return finished && hasCorrectEstimates ? totalScore : `(${totalScore})`
  }
}
