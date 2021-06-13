import React, { useCallback } from 'react'
import useTranslation from '../../util/useTranslation'
import { buildRifleTeamCompetitionsPath, buildTeamCompetitionsPath } from '../../util/routeUtil'

export default function RaceTeamCompetitions({ race }) {
  const { t } = useTranslation()
  const { sport, teamCompetitions } = race

  const oneTeamCompetition = teamCompetitions.length === 1
  const buildLink = useCallback((tc, buildPath) => {
    const { id, name } = tc
    const linkText = oneTeamCompetition ? t('teamCompetition') : name
    return <a key={id} href={buildPath(race.id, id)} className="button button--primary">{linkText}</a>
  }, [oneTeamCompetition, race.id, t])

  if (!teamCompetitions.length) return null

  return (
    <>
      <h2>{t('teamCompetitions')}</h2>
      <div className="buttons">
        {teamCompetitions.map(tc => buildLink(tc, buildTeamCompetitionsPath))}
      </div>
      {sport.european && (
        <>
          <h2>{t('rifleTeamCompetitions')}</h2>
          <div className="buttons">
            {teamCompetitions.map(tc => buildLink(tc, buildRifleTeamCompetitionsPath))}
          </div>
        </>
      )}
    </>
  )
}
