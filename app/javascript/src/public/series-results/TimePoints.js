import React from 'react'
import { seriesEnums } from '../../util/enums'

const timeFromSeconds = seconds => {
  const h = Math.floor(seconds / 3600)
  const min = Math.floor((seconds - h * 3600) / 60)
  const sec = seconds % 60
  const pad = n => n < 10 ? `0${n}` : n
  if (h >= 1) return `${h}:${pad(min)}:${pad(sec)}`
  return `${pad(min)}:${pad(sec)}`
}

export default function TimePoints({ competitor, series }) {
  const { pointsMethod } = series
  const { noResultReason, timeInSeconds, timePoints } = competitor
  if (noResultReason) {
    return ''
  } else if (pointsMethod === seriesEnums.pointsMethod.time300Points2Estimates) {
    return '300'
  } else if (!timeInSeconds) {
    return ''
  } else {
    const className = timePoints === 300 ? 'series-best-time' : ''
    return <span className={className}>{timePoints} ({timeFromSeconds(timeInSeconds)})</span>
  }
}
