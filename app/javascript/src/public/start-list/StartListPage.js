import React, { useCallback, useEffect } from 'react'
import { useParams } from 'react-router-dom'
import format from 'date-fns/format'
import DesktopStartList from './DesktopStartList'
import MobileStartList from './MobileStartList'
import SeriesMobileSubMenu from '../menu/SeriesMobileSubMenu'
import useTranslation from '../../util/useTranslation'
import { buildRacePath, buildSeriesResultsPath, buildSeriesStartListPath } from '../../util/routeUtil'
import useTitle from '../../util/useTitle'
import { pages } from '../menu/DesktopSecondLevelMenu'
import Button from '../../common/Button'
import Message from '../../common/Message'
import useLayout from '../../util/useLayout'
import useRaceData from '../../util/useRaceData'
import IncompletePage from '../../common/IncompletePage'

export default function StartListPage({ setSelectedPage }) {
  const { raceId, seriesId } = useParams()
  const { t } = useTranslation()
  const { mobile } = useLayout()
  const buildApiPath = useCallback(raceId => `/api/v2/public/races/${raceId}/series/${seriesId}/start_list`, [seriesId])
  const { error, fetching, race, raceData: series } = useRaceData(buildApiPath)
  useTitle(race && series && `${race.name} - ${series.name} - ${t('startList')}`)
  useEffect(() => setSelectedPage(pages.startList), [setSelectedPage])

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={t('startList')} />
  }

  const { competitors, id, name, started, startTime } = series
  return (
    <>
      <h2>{name} - {t('startList')}</h2>
      {startTime && !started && (
        <Message type="info">{t('seriesStartTime')}: {format(new Date(startTime), 'dd.MM.yyyy HH:mm')}</Message>
      )}
      {competitors.length > 0 && (
        <>
          {!mobile && <DesktopStartList competitors={competitors} race={race} />}
          {mobile && <MobileStartList competitors={competitors} race={race} />}
          <Button href={`/races/${raceId}/series/${seriesId}/start_list.pdf`} type="pdf">
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
