import React from 'react'
import format from 'date-fns/format'
import { formatDateInterval } from './timeUtil'

export default function DateInterval({ startDate, endDate, withTimeTag }) {
  if (!withTimeTag) {
    return formatDateInterval(startDate, endDate)
  }
  const start = format(new Date(startDate), 'dd.MM.yyyy')
  const end = endDate && startDate !== endDate && format(new Date(endDate), 'dd.MM.yyyy')
  return (
    <>
      <time itemProp="startDate" dateTime={start}>{start}</time>
      {end && ` - ${end}`}
    </>
  )
}
