import React from 'react'
import { Link } from 'react-router-dom'

export default function SeriesMobileSubMenu({ race, buildSeriesLink, currentSeriesId }) {
  if (!race || !race.series.length) return null
  return (
    <div className="buttons buttons--mobile">
      {race.series.map(series => {
        const { id, name } = series
        if (currentSeriesId === id) {
          return <div key={id} className="button button--current">{name}</div>
        }
        return <Link key={id} className="button" to={buildSeriesLink(race.id, id)}>{name}</Link>
      })}
    </div>
  )
}
