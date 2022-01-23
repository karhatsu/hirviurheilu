import React, { useEffect } from 'react'
import { useParams } from 'react-router-dom'
import useMenu, { pages } from '../../util/useMenu'
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
import MobileSubMenu from '../menu/MobileSubMenu'

export default function CupSeriesPage() {
  const { t } = useTranslation()
  const { setSelectedPage } = useMenu()
  const { cupSeriesId: csId, rifleCupSeriesId: rCsId } = useParams()
  const cupSeriesId = csId && parseInt(csId)
  const rifleCupSeriesId = rCsId && parseInt(rCsId)
  const { cup, fetching: cupFetching, error: cupError } = useCup()
  const { fetching, error, cupSeries } = useCupSeries()
  const { mobile } = useLayout()
  useEffect(() => {
    setSelectedPage(rifleCupSeriesId ? pages.cup.rifleResults : pages.cup.results)
  }, [setSelectedPage, rifleCupSeriesId])

  const titleCupSeries = (cupSeries?.id === cupSeriesId && cupSeries) ||
    (cup && cup.cupSeries.find(cs => cs.id === cupSeriesId || cs.id === rifleCupSeriesId))
  const title = cup && titleCupSeries ? `${titleCupSeries.name} - ${t('results')}` : t('results')
  useTitle(cup && `${cup.name} - ${title}`)

  if (fetching || cupFetching || error || cupError) {
    return <IncompletePage fetching={fetching || cupFetching} error={error || cupError} title={title} />
  }

  const { cupCompetitors } = cupSeries
  const ruleKey = cup.includeAlwaysLastRace ? 'cupPointsRuleWithLast' : 'cupPointsRule'
  const mobileResults = mobile || cup.races.length > 7
  return (
    <>
      <h2><CupSeriesName cupSeries={titleCupSeries} /> - {t('results')}</h2>
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
      <MobileSubMenu
        items={cup.cupSeries}
        currentId={rifleCupSeriesId || cupSeriesId}
        buildPath={rifleCupSeriesId ? buildRifleCupSeriesPath : buildCupSeriesPath}
        parentId={cup.id}
      />
      <div className="buttons buttons--nav">
        <Button to={buildCupPath(cup.id)} type="back">{t('backToCupHomePage')}</Button>
      </div>
    </>
  )
}
