import React from 'react'
import { useLocation, useParams } from 'react-router-dom'
import { useCup } from './util/useCup'
import { useRace } from './util/useRace'
import DateInterval from './util/DateInterval'
import useTranslation from './util/useTranslation'
import { matchPath } from './util/routeUtil'

export default function PageTitle() {
  const { t } = useTranslation()
  const { pathname } = useLocation()
  const { cupId, raceId } = useParams()
  const { race } = useRace()
  const { cup } = useCup()
  if (matchPath(pathname, '/announcements')) return t('announcements')
  if (matchPath(pathname, '/info')) return t('info')
  if (matchPath(pathname, '/races', true)) return `Hirviurheilu - ${t('races')}`
  const competition = (cupId && cup) || (raceId && race)
  if (!competition) return t('appTitle')
  const { name, location, startDate, endDate } = competition
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
