import React from 'react'
import useTranslation from '../../util/useTranslation'
import { Link } from 'react-router-dom'
import { buildSeriesResultsPath } from '../../util/routeUtil'
import TimePoints from '../series-results/TimePoints'
import EstimatePoints from '../series-results/EstimatePoints'
import ShootingPoints from '../series-results/ShootingPoints'
import TeamCompetitionExtraScore from './TeamCompetitionExtraScore'
import TeamCompetitionNationalRecord from './TeamCompetitionNationalRecord'

export default function TeamCompetitionsDesktopResults({ race, teamCompetition, showCompetitors }) {
  const { t } = useTranslation()
  const { hasExtraScore, teams } = teamCompetition
  return (
    <div className="results--desktop">
      <table className="results-table">
        <thead>
        <tr>
          <th />
          <th>{t('team')}</th>
          <th>{t(race.sport.shooting ? 'result' : 'points')}</th>
          {hasExtraScore && <th>{t('extraRound')}</th>}
          {showCompetitors && !race.sport.shooting && (
            <>
              <th>{t(`timeTitle_${race.sportKey}`)}</th>
              <th>{t('estimating')}</th>
              <th>{t('shooting')}</th>
            </>
          )}
          {showCompetitors && <th>{t('series')}</th>}
        </tr>
        </thead>
        <tbody>
        {teams.map((team, i) => {
          const { competitors, name, totalScore } = team
          return (
            <React.Fragment key={name}>
              <tr id={`team_${i + 1}`}>
                <td>{i + 1}.</td>
                <td className="team_name">{name}</td>
                <td className="center team_points">
                  {totalScore}
                  <TeamCompetitionNationalRecord race={race} teamCompetition={teamCompetition} team={team} i={i} />
                </td>
                {hasExtraScore && <td><TeamCompetitionExtraScore team={team} /></td>}
                {showCompetitors && <td/>}
              </tr>
              {showCompetitors && (competitors.map((competitor, j) => {
                const { ageGroup, firstName, id, lastName, series, teamCompetitionPoints } = competitor
                const seriesTitle = ageGroup ? `${series.name} (${ageGroup.name})` : series.name
                return (
                  <tr key={id} id={`team_${i + 1}_comp_${j + 1}`}>
                    <td/>
                    <td>{lastName} {firstName}</td>
                    <td className="center">{teamCompetitionPoints}</td>
                    {hasExtraScore && <td/>}
                    {!race.sport.shooting && (
                      <>
                        <td className="center"><TimePoints competitor={competitor} series={series} /></td>
                        <td className="center">
                          <EstimatePoints competitor={competitor} series={series} race={race} />
                        </td>
                        <td className="center"><ShootingPoints competitor={competitor} /></td>
                      </>
                    )}
                    <td>
                      <Link to={buildSeriesResultsPath(race.id, series.id)}>{seriesTitle}</Link>
                    </td>
                  </tr>
                )
              }))}
            </React.Fragment>
          )
        })}
        </tbody>
      </table>
    </div>
  )
}
