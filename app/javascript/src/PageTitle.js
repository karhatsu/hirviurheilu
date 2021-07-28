import React from 'react'
import { useCup } from './util/useCup'
import { useRace } from './util/useRace'
import DateInterval from './util/DateInterval'

export default function PageTitle() {
  const { race } = useRace()
  const { cup } = useCup()
  if (!race && !cup) return null
  const { name, location, startDate, endDate } = race || cup
  return (
    <span className="race-title">
      <span className="race-title__name" itemProp="name">
        {name}{' '}
      </span>
      {location && (
        <span className="race-title__location" itemProp="location" itemType="http://schema.org/Place">
          {location},{' '}
        </span>
      )}
      {startDate && (
        <span className="race-title__dates">
          <DateInterval startDate={startDate} endDate={endDate} withTimeTag={true} />
        </span>
      )}
    </span>
  )
}