import DesktopMenuItem from '../../public/menu/DesktopMenuItem'
import useOfficialMenu from './useOfficialMenu'
import { pages } from '../../util/useMenu'
import useTranslation from '../../util/useTranslation'
import {
  buildOfficialEventPath,
  buildOfficialEventCompetitorNumbersSyncPath,
  buildOfficialEventCompetitorsPath,
  buildOfficialEventPrintsPath,
} from '../../util/routeUtil'
import { useMatch, useParams } from 'react-router'

const EventSecondLevelMenu = ({ visible }) => {
  const { eventId } = useParams()
  const { t } = useTranslation()
  const { selectedPage } = useOfficialMenu()
  const newEventPage = useMatch('/official/events/new')
  if (newEventPage) return null
  return (
    <div className={`menu menu--sub menu--sub-1 ${visible ? 'menu--visible' : ''}`}>
      <DesktopMenuItem
        text={t('officialEventMenuHome')}
        path={buildOfficialEventPath(eventId)}
        reactLink={true}
        selected={selectedPage === pages.events.main}
      />
      <DesktopMenuItem
        text={t('officialEventMenuCompetitors')}
        path={buildOfficialEventCompetitorsPath(eventId)}
        reactLink={true}
        selected={selectedPage === pages.events.competitors}
      />
      <DesktopMenuItem
        text={t('officialEventMenuPrints')}
        path={buildOfficialEventPrintsPath(eventId)}
        reactLink={true}
        selected={selectedPage === pages.events.prints}
      />
      <DesktopMenuItem
        text={t('officialEventMenuSyncNumbers')}
        path={buildOfficialEventCompetitorNumbersSyncPath(eventId)}
        reactLink={true}
        selected={selectedPage === pages.events.syncNumbers}
      />
    </div>
  )
}

export default EventSecondLevelMenu
