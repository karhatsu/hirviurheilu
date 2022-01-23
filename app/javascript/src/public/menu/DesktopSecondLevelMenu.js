import React from 'react'
import { useRace } from '../../util/useRace'
import DesktopRaceSecondLevelMenu from './DesktopRaceSecondLevelMenu'
import { useCup } from '../../util/useCup'
import DesktopCupSecondLevelMenu from './DesktopCupSecondLevelMenu'
import { useLocation, useParams } from 'react-router-dom'
import DesktopInfoSecondLevelMenu from './DesktopInfoSecondLevelMenu'
import { matchPath } from '../../util/routeUtil'

export default function DesktopSecondLevelMenu() {
  const { cupId, raceId } = useParams()
  const { race } = useRace()
  const { cup } = useCup()
  const { pathname } = useLocation()
  if (['/info', '/prices', '/answers', '/feedbacks', '/sports_info'].find(path => matchPath(pathname, path))) {
    return <DesktopInfoSecondLevelMenu />
  }
  if (cupId && cup) return <DesktopCupSecondLevelMenu cup={cup} />
  if (raceId && race && !race.cancelled) return <DesktopRaceSecondLevelMenu race={race} />
  return null
}
