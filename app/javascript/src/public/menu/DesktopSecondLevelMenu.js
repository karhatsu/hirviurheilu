import React from 'react'
import { useRace } from '../../util/useRace'
import DesktopRaceSecondLevelMenu from './DesktopRaceSecondLevelMenu'
import { useCup } from '../../util/useCup'
import DesktopCupSecondLevelMenu from './DesktopCupSecondLevelMenu'
import { useLocation, useParams } from 'react-router-dom'
import DesktopInfoSecondLevelMenu from './DesktopInfoSecondLevelMenu'
import { matchPath } from '../../util/routeUtil'

export const pages = {
  raceHome: 0,
  results: 1,
  startList: 2,
  nordic: {
    trap: 3,
    shotgun: 4,
    rifle_standing: 5,
    rifle_moving: 6,
  },
  europeanRifle: 7,
  teamCompetitions: 8,
  rifleTeamCompetitions: 9,
  relays: 10,
  media: 11,
  batches: {
    qualificationRound: 12,
    finalRound: 13,
  },
  resultRotation: 14,
  cup: {
    home: 15,
    results: 16,
    rifleResults: 17,
    media: 18,
  },
  info: {
    main: 19,
    prices: 20,
    answers: 21,
    feedback: 22,
    sportsInfo: 23,
  },
}

export default function DesktopSecondLevelMenu({ selectedPage }) {
  const { cupId, raceId } = useParams()
  const { race } = useRace()
  const { cup } = useCup()
  const { pathname } = useLocation()
  if (['/info', '/prices', '/answers', '/feedbacks', '/sports_info'].find(path => matchPath(pathname, path))) {
    return <DesktopInfoSecondLevelMenu selectedPage={selectedPage} />
  }
  if (cupId && cup) return <DesktopCupSecondLevelMenu cup={cup} selectedPage={selectedPage} />
  if (raceId && race && !race.cancelled) return <DesktopRaceSecondLevelMenu race={race} selectedPage={selectedPage} />
  return null
}
