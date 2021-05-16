import React from 'react'
import { raceEnums } from '../util/enums'

export default function DesktopStartList({ competitors, race }) {
  const clubLevel = () => {
    return race.clubLevel === raceEnums.clubLevel.district ? 'Piiri' : 'Seura'
  }

  const showTeamName = !!competitors.find(c => c.teamName)
  return (
    <div className="results--desktop">
      <table className="results-table">
        <thead>
        <tr>
          <th>Nro</th>
          <th>Kilpailija</th>
          <th>{clubLevel()}</th>
          <th>Lähtöaika</th>
          {showTeamName && <th>Jotosjoukkue</th>}
        </tr>
        </thead>
        <tbody>
        {competitors.map((competitor, i) => {
          const { ageGroup, club, firstName, lastName, number, relativeStartTime, realStartTime, unofficial, teamName } = competitor
          const time = realStartTime && realStartTime !== relativeStartTime
            ? `${relativeStartTime} (${realStartTime})`
            : relativeStartTime
          return (
            <tr key={competitor.id} className={i % 2 === 0 ? 'odd' : ''}>
              <td>{number}</td>
              <td>
                {lastName} {firstName}
                {ageGroup && ` (${ageGroup.name})`}
                {unofficial && <span className="unofficial" title="Epävirallinen kilpailija">epäv.</span>}
              </td>
              <td>{club.name}</td>
              <td>{time}</td>
              {showTeamName && <td>{teamName}</td>}
            </tr>
          )
        })}
        </tbody>
      </table>
    </div>
  )
}
