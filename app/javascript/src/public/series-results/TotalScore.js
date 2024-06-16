import React from 'react'
import NoResultReason from '../NoResultReason'

export default function TotalScore({ noResultReason, totalScore, penalty }) {
  if (noResultReason) {
    return <NoResultReason noResultReason={noResultReason} type="competitor" />
  }
  return penalty ? `${totalScore} (${totalScore + penalty}-${penalty})` : totalScore
}
