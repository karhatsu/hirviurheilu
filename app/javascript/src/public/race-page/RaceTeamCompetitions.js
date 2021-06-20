import React, { useCallback } from 'react'
import useTranslation from '../../util/useTranslation'
import { buildRifleTeamCompetitionsPath, buildTeamCompetitionsPath } from '../../util/routeUtil'
import Button from '../../common/Button'

export default function RaceTeamCompetitions({ race }) {
  const { t } = useTranslation()
  const { sport, teamCompetitions } = race

  const oneTeamCompetition = teamCompetitions.length === 1
  const buildLink = useCallback((tc, buildPath, useReact) => {
    const { id, name } = tc
    const linkText = oneTeamCompetition ? t('teamCompetition') : name
    const pathProps = { [useReact ? 'to' : 'href']: buildPath(race.id, id) }
    return <Button key={id} type="primary" {...pathProps}>{linkText}</Button>
  }, [oneTeamCompetition, race.id, t])

  if (!teamCompetitions.length) return null

  return (
    <>
      <h2>{t('teamCompetitions')}</h2>
      <div className="buttons">
        {teamCompetitions.map(tc => buildLink(tc, buildTeamCompetitionsPath, true))}
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
