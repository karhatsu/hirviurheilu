import React, { useCallback, useEffect, useState } from 'react'
import { pages } from '../menu/DesktopSecondLevelMenu'
import useRaceData from '../../util/useRaceData'
import { useParams } from 'react-router-dom'
import IncompletePage from '../../common/IncompletePage'
import useTranslation from '../../util/useTranslation'
import useTitle from '../../util/useTitle'
import Message from '../../common/Message'
import useLayout from '../../util/useLayout'
import TeamCompetitionsDesktopResults from './TeamCompetitionsDesktopResults'
import Button from '../../common/Button'
import { buildRacePath, buildTeamCompetitionsPath } from '../../util/routeUtil'
import TeamCompetitionsMobileResults from './TeamCompetitionsMobileResults'

export default function TeamCompetitionResultsPage({ setSelectedPage }) {
  const { t } = useTranslation()
  const [showCompetitors, setShowCompetitors] = useState(false)
  const { teamCompetitionId } = useParams()
  const { mobile } = useLayout()
  const toggleCompetitors = useCallback(() => setShowCompetitors(show => !show), [])
  const buildApiPath = useCallback(raceId => {
    return `/api/v2/public/races/${raceId}/team_competitions/${teamCompetitionId}`
  }, [teamCompetitionId])
  const { fetching, error, race, raceData: teamCompetition } = useRaceData(buildApiPath)
  useEffect(() => setSelectedPage(pages.teamCompetitions), [setSelectedPage])
  useTitle(race && teamCompetition && `${race.name} - ${t('teamCompetitions')} - ${teamCompetition.name}`)

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={t('teamCompetition')} />
  }

  const pdfPath = `${buildTeamCompetitionsPath(race.id, teamCompetition.id)}.pdf`
  return (
    <>
      <h2>{teamCompetition.name} - {t('results')}</h2>
      {!teamCompetition.teams.length && <Message type="info">{t('teamCompetitionResultsNotAvailable')}</Message>}
      {teamCompetition.teams.length > 0 && (
        <>
          <div className="buttons">
            <Button onClick={toggleCompetitors} id="toggle_competitors">
              {t(showCompetitors ? 'hideCompetitors' : 'showCompetitors')}
            </Button>
          </div>
          {!mobile && (
            <TeamCompetitionsDesktopResults
              race={race}
              teamCompetition={teamCompetition}
              showCompetitors={showCompetitors}
            />
          )}
          {mobile && (
            <TeamCompetitionsMobileResults
              race={race}
              teamCompetition={teamCompetition}
              showCompetitors={showCompetitors}
            />
          )}
          <div className="buttons">
            <Button href={`${pdfPath}?exclude_competitors=true`} type="pdf">
              {t('downloadResultsPdfWithoutCompetitors')}
            </Button>
            <Button href={pdfPath} type="pdf">
              {t('downloadResultsPdfWithCompetitors')}
            </Button>
          </div>
        </>
      )}
      {race.teamCompetitions.length > 0 && (
        <div className="buttons buttons--mobile">
          {race.teamCompetitions.map(tc => {
            const { id, name } = tc
            if (id === parseInt(teamCompetitionId)) {
              return <Button key={id} type="current">{name}</Button>
            } else {
              return <Button key={id} to={buildTeamCompetitionsPath(race.id, id)}>{name}</Button>
            }
          })}
        </div>
      )}
      <div className="buttons buttons--nav">
        <Button to={buildRacePath(race.id)} type="back">{t('backToPage', { pageName: race.name })}</Button>
      </div>
    </>
  )
}
