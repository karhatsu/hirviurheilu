import { useRace } from '../../util/useRace'
import DesktopRaceSecondLevelMenu from './DesktopRaceSecondLevelMenu'
import { useCup } from '../../util/useCup'
import DesktopCupSecondLevelMenu from './DesktopCupSecondLevelMenu'
import { useLocation } from 'react-router'
import DesktopInfoSecondLevelMenu from './DesktopInfoSecondLevelMenu'
import { matchPath } from '../../util/routeUtil'
import { usePathParams } from '../PathParamsProvider'

export default function DesktopSecondLevelMenu() {
  const { cupId, raceId } = usePathParams()
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
