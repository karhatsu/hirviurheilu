import React from 'react'
import DesktopMenuItem from "../../public/menu/DesktopMenuItem"
import useOfficialMenu from "./useOfficialMenu"
import { pages } from "../../util/useMenu"
import useTranslation from "../../util/useTranslation"
import { buildOfficialEventPath } from "../../util/routeUtil"
import { useParams } from "react-router"

const EventSecondLevelMenu = ({ visible }) => {
  const { eventId } = useParams()
  const { t } = useTranslation()
  const { selectedPage } = useOfficialMenu()
  return (
    <div className={`menu menu--sub menu--sub-1 ${visible ? 'menu--visible' : ''}`}>
      <DesktopMenuItem
        text={t('officialEventMenuHome')}
        path={buildOfficialEventPath(eventId)}
        reactLink={true}
        selected={selectedPage === pages.events.main}
      />
    </div>
  )
}

export default EventSecondLevelMenu
