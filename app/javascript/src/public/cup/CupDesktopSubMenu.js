import React from 'react'
import { buildCupSeriesPath, buildRifleCupSeriesPath } from '../../util/routeUtil'
import DesktopMenuItem from '../menu/DesktopMenuItem'

export default function CupDesktopSubMenu({ cup, currentCupSeriesId, currentRifleCupSeriesId }) {
  if (!cup || cup.cupSeries.length < 2) return null
  return (
    <div className="menu menu--sub menu--sub-2">
      {cup.cupSeries.map(cs => {
        const { id, name } = cs
        const selected = parseInt(currentCupSeriesId || currentRifleCupSeriesId) === id
        const path = currentRifleCupSeriesId ? buildRifleCupSeriesPath(cup.id, id) : buildCupSeriesPath(cup.id, id)
        return <DesktopMenuItem key={id} path={path} text={name} selected={selected} reactLink={true} />
      })}
    </div>
  )
}
