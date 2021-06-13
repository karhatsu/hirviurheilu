import React from 'react'
import UnofficialLabel from './UnofficialLabel'

export default function DesktopResultsRows({ children, competitors, sortMethod }) {
  let prevCompetitorPosition = 0
  return (
    <tbody>
      {competitors.map((competitor, i) => {
        const { ageGroup, club, firstName, id, lastName, number, position, unofficial } = competitor
        let name = `${lastName} ${firstName}`
        if (ageGroup) {
          name = `${name} (${ageGroup.name})`
        }
        const orderNo = sortMethod ? `${i + 1}.` : position === prevCompetitorPosition ? '' : `${position}.`
        prevCompetitorPosition = position
        return (
          <tr key={id} className={i % 2 === 0 ? 'odd' : ''} id={`comp_${i + 1}`}>
            <td>{orderNo}</td>
            <td>{name} <UnofficialLabel unofficial={unofficial} /></td>
            <td>{number}</td>
            <td>{club.name}</td>
            {children(competitor)}
          </tr>
        )
      })}
    </tbody>
  )
}
