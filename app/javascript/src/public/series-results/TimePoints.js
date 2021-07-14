import React from 'react'
import { seriesEnums } from '../../util/enums'
import { timeFromSeconds } from '../../util/timeUtil'

export default function TimePoints({ competitor, series }) {
  const { pointsMethod } = series
  const { noResultReason, timeInSeconds, timePoints } = competitor
  if (noResultReason) {
    return ''
  } else if (pointsMethod === seriesEnums.pointsMethod.time300Points2Estimates) {
    return '300'
  } else if (!timeInSeconds) {
    return '-'
  } else {
    const className = timePoints === 300 ? 'series-best-time' : ''
    return <span className={className}>{timePoints} ({timeFromSeconds(timeInSeconds)})</span>
  }
}
