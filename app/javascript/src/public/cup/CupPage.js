import React, { useEffect } from 'react'
import { pages } from '../menu/DesktopSecondLevelMenu'
import { useCup } from '../../util/useCup'
import IncompletePage from '../../common/IncompletePage'
import CupPublicMessage from './CupPublicMessage'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'
import { buildCupSeriesPath, buildRacePath, buildRifleCupSeriesPath } from '../../util/routeUtil'
import CupSeriesName from './CupSeriesName'
import CupResultsPdf from './CupResultsPdf'
import useTitle from '../../util/useTitle'

export default function CupPage({ setSelectedPage }) {
  const { t } = useTranslation()
  const { fetching, cup, error } = useCup()
  useEffect(() => setSelectedPage(pages.cup.home), [setSelectedPage])
  useTitle(cup && cup.name)

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} />
  }

  const { cupSeries, hasRifle, includeAlwaysLastRace, topCompetitions, races } = cup
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
              return <Button key={race.id} to={buildRacePath(race.id)}>{race.name}</Button>
            })}
          </div>
        </>
      )}
      <CupResultsPdf cup={cup} />
      <div className="buttons buttons--nav">
        <Button to="/" type="back">{t('backToHomePage')}</Button>
      </div>
    </>
  )
}
