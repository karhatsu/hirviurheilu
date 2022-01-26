import React, { useCallback, useEffect, useState } from 'react'
import useMenu, { pages } from '../../util/useMenu'
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
import MobileSubMenu from '../menu/MobileSubMenu'

export default function TeamCompetitionResultsPage({ rifle }) {
  const { t } = useTranslation()
  const { setSelectedPage } = useMenu(rifle ? pages.rifleTeamCompetitions : pages.teamCompetitions)
  const [showCompetitors, setShowCompetitors] = useState(false)
  const teamCompetitionId = parseInt(useParams().teamCompetitionId)
  const { mobile } = useLayout()
  const toggleCompetitors = useCallback(() => setShowCompetitors(show => !show), [])
  const buildApiPath = useCallback(raceId => {
    return `/api/v2/public/races/${raceId}/${rifle ? 'rifle_' : ''}team_competitions/${teamCompetitionId}`
  }, [teamCompetitionId, rifle])
  const { fetching, error, race, raceData: teamCompetition } = useRaceData(buildApiPath)
  useEffect(() => {
    setSelectedPage(rifle ? pages.rifleTeamCompetitions : pages.teamCompetitions)
  }, [setSelectedPage, rifle])

  const titleTeamCompetition = (teamCompetition?.id === teamCompetitionId && teamCompetition) ||
    (race && race.teamCompetitions.find(tc => tc.id === teamCompetitionId))
  const titleSuffix = t(rifle ? 'rifleResults' : 'results')
  const title = titleTeamCompetition ? `${titleTeamCompetition.name} - ${titleSuffix}` : titleSuffix
  useTitle(race && titleTeamCompetition &&
    [titleTeamCompetition.name, t('teamCompetitions'), race.name, t(`sport_${race.sportKey}`)])

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={title} />
  }

  const pdfPath = `${buildTeamCompetitionsPath(race.id, teamCompetition.id)}.pdf`
  return (
    <>
      <h2>{title}</h2>
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
      <MobileSubMenu
        items={race.teamCompetitions}
        currentId={teamCompetitionId}
        parentId={race.id}
        buildPath={buildTeamCompetitionsPath}
      />
      <div className="buttons buttons--nav">
        <Button to={buildRacePath(race.id)} type="back">{t('backToPage', { pageName: race.name })}</Button>
      </div>
    </>
  )
}
