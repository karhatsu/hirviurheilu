import React from 'react'

export default function MobileStartList({ competitors }) {
  return (
    <div className="results--mobile result-cards">
      {competitors.map((competitor, i) => {
        const {
          ageGroup,
          club,
          id,
          firstName,
          lastName,
          number,
          relativeStartTime,
          realStartTime,
          teamName,
        } = competitor
        return (
          <div key={id} className={`card${i % 2 === 0 ? ' card--odd' : ''}`}>
            <div className="card__number">{number}</div>
            <div className="card__middle">
              <div className="card__name">
                {lastName} {firstName}
                {ageGroup && <div className="card__name__extra">({ageGroup.name})</div>}
              </div>
              <div className="card__middle-row">
                {club.name}{teamName ? ` (${teamName})` : ''}
              </div>
            </div>
            <div className="card__main-value">
              <div>{relativeStartTime}</div>
              {realStartTime && realStartTime !== relativeStartTime && <div>({realStartTime})</div>}
            </div>
          </div>
        )
      })}
    </div>
  )
}
