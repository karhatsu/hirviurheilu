import React from 'react'
import NoResultReason from '../NoResultReason'

export default function Points({ competitor }) {
  const { finished, hasCorrectEstimates, noResultReason, points } = competitor
  if (noResultReason) {
    return <NoResultReason noResultReason={noResultReason} type="competitor" />
  } else if (!points) {
    return '-'
  } else {
    return finished && hasCorrectEstimates ? points : `(${points})`
  }
}
