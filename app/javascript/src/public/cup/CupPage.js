import React, { useEffect } from 'react'
import useMenu, { pages } from '../../util/useMenu'
import { useCup } from '../../util/useCup'
import IncompletePage from '../../common/IncompletePage'
import CupPublicMessage from './CupPublicMessage'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'
import {
  buildCupSeriesPath,
  buildCupTeamCompetitionsPath,
  buildRacePath,
  buildRifleCupSeriesPath,
  buildRootPath,
} from '../../util/routeUtil'
import CupSeriesName from './CupSeriesName'
import CupResultsPdf from './CupResultsPdf'
import useTitle from '../../util/useTitle'
import { formatDateInterval } from '../../util/timeUtil'

export default function CupPage() {
  const { t } = useTranslation()
  const { setSelectedPage } = useMenu()
  const { fetching, cup, error } = useCup()
  useEffect(() => setSelectedPage(pages.cup.home), [setSelectedPage])
  useTitle(cup && cup.name)

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} />
  }

  const { cupSeries, cupTeamCompetitions, hasRifle, includeAlwaysLastRace, topCompetitions, races } = cup
  const ruleKey = includeAlwaysLastRace ? 'cupPointsRuleWithLast' : 'cupPointsRule'
  return (
    <>
      <CupPublicMessage cup={cup} />
      <h2>{t('results')}</h2>
      {!cupSeries.length && t('noCupSeries')}
      {cupSeries.length > 0 && (
        <div className="buttons">
          {cupSeries.map(cs => {
            return (
              <Button key={cs.id} to={buildCupSeriesPath(cup.id, cs.id)} type="primary">
                <CupSeriesName cupSeries={cs} />
              </Button>
            )
          })}
        </div>
      )}
      {cupTeamCompetitions.length > 0 && (
        <>
          <h2>{t('teamCompetitions')}</h2>
          <div className="buttons">
            {cupTeamCompetitions.map(tc => (
              <Button key={tc.id} to={buildCupTeamCompetitionsPath(cup.id, tc.id)} type="primary">
                {tc.name}
              </Button>
            ))}
          </div>
        </>
      )}
      {hasRifle && cupSeries.length > 0 && (
        <>
          <h2>{t('rifleResults')}</h2>
          <div className="buttons">
            {cupSeries.map(cs => {
              return (
                <Button key={cs.id} to={buildRifleCupSeriesPath(cup.id, cs.id)} type="primary">
                  <CupSeriesName cupSeries={cs} />
                </Button>
              )
            })}
          </div>
        </>
      )}
      <h2>{t('cupPointsRuleTitle')}</h2>
      <div>{t(ruleKey, { bestCompetitionsCount: topCompetitions })}</div>
      {races.length > 0 && (
        <>
          <h2>{t('cupCompetitions')}</h2>
          <div className="buttons">
            {races.map(race => {
              const { id, name, startDate, endDate } = race
              return <Button key={id} to={buildRacePath(id)}>{name} ({formatDateInterval(startDate, endDate)})</Button>
            })}
          </div>
        </>
      )}
      <CupResultsPdf cup={cup} />
      <div className="buttons buttons--nav">
        <Button to={buildRootPath()} type="back">{t('backToHomePage')}</Button>
      </div>
    </>
  )
}
