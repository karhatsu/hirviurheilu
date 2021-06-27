import React from 'react'
import DesktopMenuItem from '../menu/DesktopMenuItem'
import { buildRelayPath } from '../../util/routeUtil'

export default function RelayDesktopSubMenu({ currentRelayId, race }) {
  if (!race || race.relays.length < 2) return null
  return (
    <div className="menu menu--sub menu--sub-2">
      {race.relays.map(relay => {
        const { id, name } = relay
        const selected = parseInt(currentRelayId) === id
        const path = buildRelayPath(race.id, id)
        return <DesktopMenuItem key={id} path={path} text={name} selected={selected} reactLink={true} />
      })}
    </div>
  )
}
