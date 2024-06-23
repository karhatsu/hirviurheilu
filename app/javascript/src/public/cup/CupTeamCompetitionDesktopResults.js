import React from 'react'
import useTranslation from '../../util/useTranslation'
import CupTeamCompetitionPoints from './CupTeamCompetitionPoints'

const CupTeamCompetitionDesktopResults = ({ cup, cupTeamCompetition }) => {
  const { t } = useTranslation()
  const { races } = cup
  const { cupTeams } = cupTeamCompetition

  return (
    <div className="cup_results results--desktop">
      <table className="results-table">
        <thead>
        <tr>
          <th />
          <th>{t('competitor')}</th>
          {races.map(race => <th key={race.id}>{race.name}</th>)}
          <th>{t('totalPoints')}</th>
        </tr>
        </thead>
        <tbody>
        {cupTeams.map((cupTeam, i) => {
          const { name, score, partialScore } = cupTeam
          return (
            <tr key={name} id={`comp_${i + 1}`} className={i % 2 === 0 ? 'odd' : ''}>
              <td>{i + 1}.</td>
              <td>{name}</td>
              {cupTeam.races.map(race => {
                const { id, team, name } = race
                return (
                  <td key={name} className="center">
                    <CupTeamCompetitionPoints raceId={id} team={team} cupTeam={cupTeam} />
                  </td>
                )
              })}
              <td className="center total-points">{score || (partialScore && `(${partialScore})`)}</td>
            </tr>
          )
        })}
        </tbody>
      </table>
    </div>
  )
}

export default CupTeamCompetitionDesktopResults
