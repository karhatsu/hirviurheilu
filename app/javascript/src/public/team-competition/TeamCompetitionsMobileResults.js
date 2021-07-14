import React from 'react'
import classnames from 'classnames-minimal'
import TeamCompetitionNationalRecord from './TeamCompetitionNationalRecord'
import TeamCompetitionExtraScore from './TeamCompetitionExtraScore'
import useTranslation from '../../util/useTranslation'

export default function TeamCompetitionsMobileResults({ race, teamCompetition, showCompetitors }) {
  const { t } = useTranslation()
  const { hasExtraScore, teams } = teamCompetition
  return (
    <div className="results--mobile result-cards">
      {teams.map((team, i) => {
        const { competitors, name, totalScore } = team
        const className = classnames({ card: true, 'card--odd': i % 2 === 0 })
        return (
          <div className={className} key={name}>
            <div className="card__number">{i + 1}.</div>
            <div className="card__middle">
              <div className="card__name">{name}</div>
              {hasExtraScore && team.hasExtraScore && (
                <div className="card__middle-row">
                  {t('extraRound')}:{' '}
                  <TeamCompetitionExtraScore team={team} />
                </div>
              )}
              {showCompetitors && (
                <div className="card__middle-row">
                  {competitors.map(competitor => {
                    const { ageGroup, firstName, id, lastName, series, teamCompetitionPoints } = competitor
                    const seriesTitle = ageGroup ? `${series.name} (${ageGroup.name})` : series.name
                    return <div key={id}>{lastName} {firstName}, {seriesTitle}, {teamCompetitionPoints}</div>
                  })}
                </div>
              )}
            </div>
            <div className="card__main-value">
              {totalScore}
              <TeamCompetitionNationalRecord race={race} teamCompetition={teamCompetition} team={team} i={i} />
            </div>
          </div>
        )
      })}
    </div>
  )
}
