import React from 'react'
import { useLocation } from 'react-router'
import { useCup } from '../util/useCup'
import { useRace } from '../util/useRace'
import DateInterval from '../util/DateInterval'
import useTranslation from '../util/useTranslation'
import { matchPath } from '../util/routeUtil'
import { usePathParams } from '../public/PathParamsProvider'

export default function PageTitle() {
  const { t } = useTranslation()
  const { pathname } = useLocation()
  const { cupId, raceId } = usePathParams()
  const { race } = useRace()
  const { cup } = useCup()
  if (matchPath(pathname, '/announcements')) return t('announcements')
  if (matchPath(pathname, '/answers')) return t('qAndA')
  if (matchPath(pathname, '/info')) return t('info')
  if (matchPath(pathname, '/prices')) return t('prices')
  if (matchPath(pathname, '/feedbacks')) return t('sendFeedback')
  if (matchPath(pathname, '/sports_info')) return t('sportsInfo')
  if (matchPath(pathname, '/races', true)) return `Hirviurheilu - ${t('races')}`
  const competition = (cupId && cup) || (raceId && race)
  if (!competition) return t('appTitle')
  const { name, location, startDate, endDate, sportKey } = competition
  return (
    <div className="race-title">
      <div className="race-title__name" itemProp="name">
        {name}{' '}
      </div>
      <div>
        {sportKey && (
          <span className="race-title__sport">
            {t(`sport_${sportKey}`)},{' '}
          </span>
        )}
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
      </div>
    </div>
  )
}
