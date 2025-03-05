import NoResultReason from '../NoResultReason'

export default function TotalScore({ noResultReason, totalScore, penalty }) {
  if (noResultReason) {
    return <NoResultReason noResultReason={noResultReason} type="competitor" />
  }
  if (!penalty) return totalScore
  return <>{totalScore} <span style={{ whiteSpace: 'nowrap' }}>({totalScore + penalty}-{penalty})</span></>
}
