import classnames from 'classnames-minimal'
import TeamCompetitionNationalRecord from './TeamCompetitionNationalRecord'
import TeamCompetitionExtraScore from './TeamCompetitionExtraScore'
import useTranslation from '../../util/useTranslation'

export default function TeamCompetitionsMobileResults({ race, teamCompetition, showCompetitors }) {
  const { t } = useTranslation()
  const { hasExtraScore, teams } = teamCompetition
  let prevCompetitorPosition = 0
  return (
    <div className="results--mobile result-cards">
      {teams.map((team, i) => {
        const { competitors, name, position, totalScore } = team
        const orderNo = position === prevCompetitorPosition ? '' : `${position}.`
        prevCompetitorPosition = position
        const className = classnames({ card: true, 'card--odd': i % 2 === 0 })
        return (
          <div className={className} key={name}>
            <div className="card__number">{orderNo}</div>
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
                    const { ageGroup, firstName, id, lastName, series, teamCompetitionScore } = competitor
                    const seriesTitle = ageGroup ? `${series.name} (${ageGroup.name})` : series.name
                    return <div key={id}>{lastName} {firstName}, {seriesTitle}, {teamCompetitionScore}</div>
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
