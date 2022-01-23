import React, { useCallback, useEffect } from 'react'
import { useParams } from 'react-router-dom'
import format from 'date-fns/format'
import DesktopStartList from './DesktopStartList'
import MobileStartList from './MobileStartList'
import SeriesMobileSubMenu from '../menu/SeriesMobileSubMenu'
import useTranslation from '../../util/useTranslation'
import { buildRacePath, buildSeriesResultsPath, buildSeriesStartListPath } from '../../util/routeUtil'
import useTitle from '../../util/useTitle'
import useMenu, { pages } from '../../util/useMenu'
import Button from '../../common/Button'
import Message from '../../common/Message'
import useLayout from '../../util/useLayout'
import useRaceData from '../../util/useRaceData'
import IncompletePage from '../../common/IncompletePage'

export default function StartListPage() {
  const { setSelectedPage } = useMenu()
  const { raceId, seriesId: seriesIdStr } = useParams()
  const seriesId = parseInt(seriesIdStr)
  const { t } = useTranslation()
  const { mobile } = useLayout()
  const buildApiPath = useCallback(raceId => `/api/v2/public/races/${raceId}/series/${seriesId}/start_list`, [seriesId])
  const { error, fetching, race, raceData: series } = useRaceData(buildApiPath)

  const titleSeries = (series?.id === seriesId && series) || (race && race.series.find(s => s.id === seriesId))
  const title = titleSeries ? `${titleSeries.name} - ${t('startList')}` : t('startList')
  useTitle(race && titleSeries && `${race.name} - ${title}`)
  useEffect(() => setSelectedPage(pages.startList), [setSelectedPage])

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={title} />
  }

  const { competitors, id, started, startTime } = series
  return (
    <>
      <h2>{title}</h2>
      {startTime && !started && (
        <Message type="info">{t('seriesStartTime')}: {format(new Date(startTime), 'dd.MM.yyyy HH:mm')}</Message>
      )}
      {competitors.length > 0 && (
        <>
          {!mobile && <DesktopStartList competitors={competitors} race={race} />}
          {mobile && <MobileStartList competitors={competitors} race={race} />}
          <Button href={`${buildSeriesStartListPath(raceId, seriesId)}.pdf`} type="pdf">
            {t('downloadStartListPdf')}
          </Button>
        </>
      )}
      {!competitors.length && <Message type="info">{t('noCompetitorsOrStartTimes')}</Message>}
      <SeriesMobileSubMenu race={race} buildSeriesPath={buildSeriesStartListPath} currentSeriesId={id} />
      <div className="buttons buttons--nav">
        <Button to={buildRacePath(race.id)} type="back">
          {t('backToPage', { pageName: race.name })}
        </Button>
        <Button to={buildSeriesResultsPath(race.id, series.id)}>{t('results')}</Button>
      </div>
    </>
  )
}
