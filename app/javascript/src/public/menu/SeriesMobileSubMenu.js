import React from 'react'
import Button from '../../common/Button'
import useLayout from '../../util/useLayout'

export default function SeriesMobileSubMenu({ race, buildSeriesPath, currentSeriesId }) {
  const { mobile } = useLayout()
  if (!mobile || !race || !race.series.length) return null
  return (
    <div className="buttons buttons--mobile">
      {race.series.map(series => {
        const { id, name } = series
        if (currentSeriesId === id) {
          return <Button key={id} type="current">{name}</Button>
        }
        return <Button key={id} to={buildSeriesPath(race.id, id)}>{name}</Button>
      })}
    </div>
  )
}
