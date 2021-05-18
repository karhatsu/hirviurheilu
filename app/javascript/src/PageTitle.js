import React from 'react'
import { useRace } from './util/useRace'
import DateInterval from './util/DateInterval'

export default function PageTitle() {
  const { race } = useRace()
  if (!race) return null
  return (
    <span className="race-title">
      <span className="race-title__name" itemProp="name">
        {race.name}{' '}
      </span>
      <span className="race-title__location" itemProp="location" itemType="http://schema.org/Place">
        {race.location},{' '}
      </span>
      <span className="race-title__dates">
        <DateInterval startDate={race.startDate} endDate={race.endDate} withTimeTag={true} />
      </span>
    </span>
  )
}
