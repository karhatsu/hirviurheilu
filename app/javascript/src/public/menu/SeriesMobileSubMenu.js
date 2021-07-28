import React from 'react'
import MobileSubMenu from './MobileSubMenu'

export default function SeriesMobileSubMenu({ race, buildSeriesPath, currentSeriesId }) {
  if (!race) return null
  return <MobileSubMenu
    items={race.series}
    currentId={currentSeriesId}
    buildPath={buildSeriesPath}
    parentId={race.id}
  />
}
