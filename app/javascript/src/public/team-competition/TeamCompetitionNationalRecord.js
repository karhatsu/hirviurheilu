import React from 'react'

const nationalRecordUrl = 'https://smlkilpailut.fi/fi/info/tuloksia/suomen-ennatykset'

export default function TeamCompetitionNationalRecord({ race, teamCompetition, team, i }) {
  const { totalScore } = team
  const { nationalRecord } = teamCompetition
  if (!totalScore || !nationalRecord || totalScore < nationalRecord || i > 0) return null
  const text = `SE${totalScore === nationalRecord ? ' (sivuaa)' : ''}${race.finished ? '' : '?'}`
  return (
    <span className="explanation">
      {' '}<a href={nationalRecordUrl} target="_blank" rel="noreferrer">{text}</a>
    </span>
  )
}
