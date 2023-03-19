import React from 'react'
import { nationalRecordUrl } from '../../util/sportUtil'

export default function NationalRecord({ race, series, competitor }) {
  const { points, position } = competitor
  const { nationalRecord } = series
  if (!points || !nationalRecord || points < nationalRecord || position > 1) return null
  const text = `${points === nationalRecord ? '=' : ''}SE${race.finished || series.finished ? '' : '?'}`
  return (
    <span className="explanation">
      {' '}<a href={nationalRecordUrl} target="_blank" rel="noreferrer">{text}</a>
    </span>
  )
}
