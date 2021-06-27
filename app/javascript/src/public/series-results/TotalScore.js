import React from 'react'
import NoResultReason from '../NoResultReason'

export default function TotalScore({ noResultReason, totalScore }) {
  if (noResultReason) {
    return <NoResultReason noResultReason={noResultReason} type="competitor" />
  }
  return totalScore
}
