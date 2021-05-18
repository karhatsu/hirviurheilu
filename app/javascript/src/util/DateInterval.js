import React from 'react'
import format from 'date-fns/format'

export default function DateInterval({ startDate, endDate, withTimeTag }) {
  const start = format(new Date(startDate), 'dd.MM.yyyy')
  const end = endDate && startDate !== endDate && format(new Date(endDate), 'dd.MM.yyyy')
  if (!withTimeTag) {
    return end ? `${start} - ${end}` : start
  }
  return (
    <>
      <time itemProp="startDate" dateTime={start}>{start}</time>
      {end && ` - ${end}`}
    </>
  )
}
