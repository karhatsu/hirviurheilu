import React from 'react'

export default function MobileResultCards({ children, competitors }) {
  let prevCompetitorPosition = 0
  return (
    <div className="results--mobile result-cards">
      {competitors.map((competitor, i) => {
        const { id, position } = competitor
        const orderNo = position === prevCompetitorPosition ? '' : `${position}.`
        prevCompetitorPosition = position
        return (
          <div className={`card ${i % 2 === 0 ? 'card--odd' : ''}`} key={id}>
            <div className="card__number">{orderNo}</div>
            {children(competitor)}
          </div>
        )
      })}
    </div>
  )
}
