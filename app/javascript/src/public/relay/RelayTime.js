import React from 'react'
import { timeFromSeconds } from '../../util/timeUtil'

export default function RelayTime({ timeInSeconds, timeWithPenalties, noResultReason, rowBreak }) {
  if (noResultReason) {
    return ''
  } else if (!timeInSeconds) {
    return null
  } else if (timeWithPenalties !== undefined) {
    if (rowBreak) {
      return (
        <>
          <div>{timeFromSeconds(timeWithPenalties)}</div>
          <div>({timeFromSeconds(timeInSeconds)})</div>
        </>
      )
    } else {
      return `${timeFromSeconds(timeWithPenalties)} (${timeFromSeconds(timeInSeconds)})`
    }
  } else {
    return timeFromSeconds(timeInSeconds)
  }
}
