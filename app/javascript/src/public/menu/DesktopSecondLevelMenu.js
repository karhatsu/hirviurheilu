import React from 'react'
import { useRace } from '../../util/useRace'
import DesktopRaceSecondLevelMenu from './DesktopRaceSecondLevelMenu'
import { useCup } from '../../util/useCup'
import DesktopCupSecondLevelMenu from './DesktopCupSecondLevelMenu'
import { useParams } from 'react-router-dom'

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
  cup: {
    home: 14,
    results: 15,
    rifleResults: 16,
  },
}

export default function DesktopSecondLevelMenu({ selectedPage }) {
  const { cupId, raceId } = useParams()
  const { race } = useRace()
  const { cup } = useCup()
  if (cupId && cup) return <DesktopCupSecondLevelMenu cup={cup} selectedPage={selectedPage} />
  if (raceId && race && !race.cancelled) return <DesktopRaceSecondLevelMenu race={race} selectedPage={selectedPage} />
  return null
}
