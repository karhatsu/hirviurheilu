import React, { useCallback } from 'react'
import Button from '../../common/Button'
import useTranslation from '../../util/useTranslation'
import { buildNordicResultsPath, buildNordicSeriesResultsPath } from '../../util/routeUtil'
import MobileSubMenu from '../menu/MobileSubMenu'
import { useParams } from 'react-router-dom'

export default function NordicSubSportMobileSubMenu({ currentSubSport, race }) {
  const { seriesId, subSport } = useParams()
  const { t } = useTranslation()
  const buildSeriesPath = useCallback((raceId, seriesId) => {
    return buildNordicSeriesResultsPath(raceId, seriesId, subSport)
  }, [subSport])
  const { nordicSubResultsForSeries } = race

  if (nordicSubResultsForSeries) {
    return (
      <div className="buttons buttons--mobile">
        <MobileSubMenu
          items={race.series}
          currentId={seriesId}
          buildPath={buildSeriesPath}
          parentId={race.id}
        />
      </div>
    )
  }

  return (
    <div className="buttons buttons--mobile">
      {['trap', 'shotgun', 'rifle_moving', 'rifle_standing'].map(subSport => {
        const label = t(`nordic_${subSport}`)
        if (currentSubSport === subSport) {
          return <Button key={subSport} type="current">{label}</Button>
        }
        return <Button key={subSport} to={buildNordicResultsPath(race.id, subSport)}>{label}</Button>
      })}
    </div>
  )
}
