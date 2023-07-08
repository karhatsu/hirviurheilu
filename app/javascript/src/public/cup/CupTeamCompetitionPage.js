import React from 'react'
import Button from '../../common/Button'
import { buildCupPath, buildCupTeamCompetitionsPath } from '../../util/routeUtil'
import useTranslation from '../../util/useTranslation'
import IncompletePage from '../../common/IncompletePage'
import { useCup } from '../../util/useCup'
import useCupTeamCompetition from './useCupTeamCompetition'
import useTitle from '../../util/useTitle'
import { useParams } from 'react-router-dom'
import MobileSubMenu from '../menu/MobileSubMenu'
import Message from '../../common/Message'
import useLayout from '../../util/useLayout'
import CupTeamCompetitionDesktopResults from './CupTeamCompetitionDesktopResults'
import CupTeamCompetitionMobileResults from './CupTeamCompetitionMobileResults'

const CupTeamCompetitionPage = () => {
  const { t } = useTranslation()
  const { cupTeamCompetitionId: ctcId } = useParams()
  const cupTeamCompetitionId = ctcId && parseInt(ctcId)
  const { cup, fetching: cupFetching, error: cupError } = useCup()
  const { fetching, error, cupTeamCompetition } = useCupTeamCompetition()
  const { mobile } = useLayout()

  const titleCupTeamCompetition = (cupTeamCompetition?.id === cupTeamCompetitionId && cupTeamCompetition) ||
    (cup?.cupTeamCompetitions.find(ctc => ctc.id === cupTeamCompetitionId))
  const title = cup && titleCupTeamCompetition ? `${titleCupTeamCompetition.name} - ${t('results')}` : t('results')
  useTitle(cup && [title, cup.name])

  if (fetching || cupFetching || error || cupError) {
    return <IncompletePage fetching={fetching || cupFetching} error={error || cupError} title={title} />
  }

  const { cupTeams } = cupTeamCompetition
  const ruleKey = cup.includeAlwaysLastRace ? 'cupPointsRuleWithLast' : 'cupPointsRule'
  const mobileResults = mobile || cup.races.length > 7

  return (
    <>
      <h2>{title}</h2>
      {!cupTeams.length && <Message type="info">{t('teamCompetitionResultsNotAvailable')}</Message>}
      {cupTeams.length > 0 && (
        <>
          <Message type="info">{t(ruleKey, { bestCompetitionsCount: cup.topCompetitions })}</Message>
          {!mobileResults && <CupTeamCompetitionDesktopResults cup={cup} cupTeamCompetition={cupTeamCompetition} />}
          {mobileResults && (
            <div className="results--mobile results--desktop">
              <CupTeamCompetitionMobileResults cupTeamCompetition={cupTeamCompetition} />
            </div>
          )}
        </>
      )}
      <MobileSubMenu
        items={cup.cupTeamCompetitions}
        currentId={cupTeamCompetitionId}
        buildPath={buildCupTeamCompetitionsPath}
        parentId={cup.id}
      />
      <div className="buttons buttons--nav">
        <Button to={buildCupPath(cup.id)} type="back">{t('backToCupHomePage')}</Button>
      </div>
    </>
  )
}

export default CupTeamCompetitionPage
