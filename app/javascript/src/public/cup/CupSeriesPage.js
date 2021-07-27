import React, { useEffect } from 'react'
import { useParams } from 'react-router-dom'
import { pages } from '../menu/DesktopSecondLevelMenu'
import useCupSeries from './useCupSeries'
import IncompletePage from '../../common/IncompletePage'
import useTranslation from '../../util/useTranslation'
import CupSeriesName from './CupSeriesName'
import useTitle from '../../util/useTitle'
import { useCup } from '../../util/useCup'
import Message from '../../common/Message'
import CupDesktopResults from './CupDesktopResults'
import CupMobileResults from './CupMobileResults'
import useLayout from '../../util/useLayout'
import Button from '../../common/Button'
import { buildCupPath, buildCupSeriesPath, buildRifleCupSeriesPath } from '../../util/routeUtil'

export default function CupSeriesPage({ setSelectedPage }) {
  const { t } = useTranslation()
  const { cupSeriesId, rifleCupSeriesId } = useParams()
  const { cup, fetching: cupFetching, error: cupError } = useCup()
  const { fetching, error, cupSeries } = useCupSeries()
  const { mobile } = useLayout()
  useEffect(() => {
    setSelectedPage(rifleCupSeriesId ? pages.cup.rifleResults : pages.cup.results)
  }, [setSelectedPage, rifleCupSeriesId])
  useTitle(cup && cupSeries && `${cup.name} - ${cupSeries.name} - ${t('results')}`)

  if (fetching || cupFetching || error || cupError) {
    return <IncompletePage fetching={fetching || cupFetching} error={error || cupError} title={t('results')} />
  }

  const { cupCompetitors } = cupSeries
  const ruleKey = cup.includeAlwaysLastRace ? 'cupPointsRuleWithLast' : 'cupPointsRule'
  const mobileResults = mobile || cup.races.length > 7
  return (
    <>
      <h2><CupSeriesName cupSeries={cupSeries} /> - {t('results')}</h2>
      {!cupCompetitors.length && <Message type="info">{t('seriesNoCompetitors')}</Message>}
      {cupCompetitors.length > 0 && (
        <>
          <Message type="info">{t(ruleKey, { bestCompetitionsCount: cup.topCompetitions })}</Message>
          {!mobileResults && <CupDesktopResults cup={cup} cupSeries={cupSeries} />}
          {mobileResults && (
            <div className="results--mobile results--desktop">
              <CupMobileResults cup={cup} cupSeries={cupSeries} />
            </div>
          )}
          <div className="buttons">
            <Button href={`${buildCupSeriesPath(cup.id, cupSeries.id)}.pdf`} type="pdf">
              {t('downloadResultsPdf')}
            </Button>
          </div>
        </>
      )}
      {mobile && (
        <div className="buttons buttons--mobile">
          {cup.cupSeries.map(cs => {
            const { id, name } = cs
            if (id === parseInt(rifleCupSeriesId || cupSeriesId)) {
              return <Button key={id} type="primary">{name}</Button>
            }
            const path = rifleCupSeriesId ? buildRifleCupSeriesPath(cup.id, id) : buildCupSeriesPath(cup.id, id)
            return <Button key={id} to={path}>{name}</Button>
          })}
        </div>
      )}
      <div className="buttons buttons--nav">
        <Button to={buildCupPath(cup.id)} type="back">{t('backToCupHomePage')}</Button>
      </div>
    </>
  )
}
