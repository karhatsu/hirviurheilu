import React from 'react'
import DesktopMenuItem from '../menu/DesktopMenuItem'
import { buildTeamCompetitionsPath } from '../../util/routeUtil'

export default function TeamCompetitionDesktopSubMenu({ currentTeamCompetitionId, race }) {
  if (!race || race.teamCompetitions.length < 2) return null
  return (
    <div className="menu menu--sub menu--sub-2">
      {race.teamCompetitions.map(teamCompetition => {
        const { id, name } = teamCompetition
        const selected = parseInt(currentTeamCompetitionId) === id
        const path = buildTeamCompetitionsPath(race.id, id)
        return <DesktopMenuItem key={id} path={path} text={name} selected={selected} reactLink={true} />
      })}
    </div>
  )
}
