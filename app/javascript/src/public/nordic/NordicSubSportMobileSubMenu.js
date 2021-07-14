import React from 'react'
import Button from '../../common/Button'
import useTranslation from '../../util/useTranslation'
import { buildNordicResultsPath } from '../../util/routeUtil'

export default function NordicSubSportMobileSubMenu({ currentSubSport, race }) {
  const { t } = useTranslation()
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
