import React, { useCallback } from 'react'
import useTranslation from '../util/useTranslation'
import { buildRifleTeamCompetitionsLink, buildTeamCompetitionsLink } from '../util/routeUtil'

export default function RaceTeamCompetitions({ race }) {
  const { t } = useTranslation()
  const { sport, teamCompetitions } = race
  if (!teamCompetitions.length) return null

  const oneTeamCompetition = teamCompetitions.length === 1
  const buildLink = useCallback((tc, buildPath) => {
    const { id, name } = tc
    const linkText = oneTeamCompetition ? t('teamCompetition') : name
    return <a key={id} href={buildPath(race.id, id)} className="button button--primary">{linkText}</a>
  }, [oneTeamCompetition])

  return (
    <>
      <h2>{t('teamCompetitions')}</h2>
      <div className="buttons">
        {teamCompetitions.map(tc => buildLink(tc, buildTeamCompetitionsLink))}
      </div>
      {sport.european && (
        <>
          <h2>{t('rifleTeamCompetitions')}</h2>
          <div className="buttons">
            {teamCompetitions.map(tc => buildLink(tc, buildRifleTeamCompetitionsLink))}
          </div>
        </>
      )}
    </>
  )
}
