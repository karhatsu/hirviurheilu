import React from 'react'
import { Link } from 'react-router-dom'

export default function SeriesMobileSubMenu({ allSeries, buildSeriesLink, currentSeriesId }) {
  if (!allSeries.length) return null
  return (
    <div className="buttons buttons--mobile">
      {allSeries.map(series => {
        const { id, name } = series
        if (currentSeriesId === id) {
          return <div key={id} className="button button--current">{name}</div>
        }
        return <Link key={id} className="button" to={buildSeriesLink(id)}>{name}</Link>
      })}
    </div>
  )
}
