import { useLocation } from 'react-router'
import { useCup } from '../util/useCup'
import useMinimalRace from '../util/useMinimalRace'
import DateInterval from '../util/DateInterval'
import useTranslation from '../util/useTranslation'
import { matchPath } from '../util/routeUtil'
import { usePathParams } from '../public/PathParamsProvider'
import { useEvent } from '../util/useEvent'
import useAppData from '../util/useAppData'

export default function PageTitle() {
  const { t } = useTranslation()
  const { pathname } = useLocation()
  const { cupId, raceId } = usePathParams()
  const race = useMinimalRace()
  const { cup } = useCup()
  const { cup: ssCup } = useAppData()
  const { event } = useEvent()
  if (matchPath(pathname, '/announcements')) return t('announcements')
  if (matchPath(pathname, '/answers')) return t('qAndA')
  if (matchPath(pathname, '/info')) return t('info')
  if (matchPath(pathname, '/prices')) return t('prices')
  if (matchPath(pathname, '/feedbacks')) return t('sendFeedback')
  if (matchPath(pathname, '/sports_info')) return t('sportsInfo')
  if (matchPath(pathname, '/official/events/new')) return t('eventsNew')
  if (matchPath(pathname, '/races', true)) return `Hirviurheilu - ${t('races')}`
  if (event) return event.name
  const competition = (cupId && (cup || ssCup)) || (raceId && race)
  if (!competition) return t('appTitle')
  const { name, location, startDate, endDate, sportKey } = competition
  return (
    <div className="race-title">
      <div className="race-title__name" itemProp="name">
        {name}{' '}
      </div>
      <div>
        {sportKey && <span className="race-title__sport">{t(`sport_${sportKey}`)}, </span>}
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
