import React from 'react'
import DesktopMenuItem from './DesktopMenuItem'

export default function SeriesDesktopSubMenu({ race, buildSeriesPath, currentSeriesId }) {
  if (!race || race.series.length < 2) return null
  return (
    <div className="menu menu--sub menu--sub-2">
      {race.series.map(series => {
        const { id, name } = series
        const selected = parseInt(currentSeriesId) === id
        const path = buildSeriesPath(race.id, id)
        return <DesktopMenuItem key={id} path={path} text={name} selected={selected} reactLink={true} />
      })}
    </div>
  )
}
