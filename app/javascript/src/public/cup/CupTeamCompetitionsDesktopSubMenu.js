import React from 'react'
import { buildCupTeamCompetitionsPath } from '../../util/routeUtil'
import DesktopMenuItem from '../menu/DesktopMenuItem'

export default function CupTeamCompetitionsDesktopSubMenu({ cup, currentCupTeamCompetitionId }) {
  if (!cup || cup.cupTeamCompetitions.length < 2) return null
  return (
    <div className="menu menu--sub menu--sub-2">
      {cup.cupTeamCompetitions.map(ctc => {
        const { id, name } = ctc
        const selected = parseInt(currentCupTeamCompetitionId) === id
        const path = buildCupTeamCompetitionsPath(cup.id, id)
        return <DesktopMenuItem key={id} path={path} text={name} selected={selected} reactLink={true} />
      })}
    </div>
  )
}
