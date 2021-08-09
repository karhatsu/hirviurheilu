import React, { useCallback, useEffect, useMemo, useState } from 'react'
import max from 'date-fns/max'
import parseISO from 'date-fns/parseISO'
import useTitle from '../../util/useTitle'
import { useParams } from 'react-router-dom'
import { pages } from '../menu/DesktopSecondLevelMenu'
import useTranslation from '../../util/useTranslation'
import { buildRacePath, buildSeriesResultsPath, buildSeriesStartListPath } from '../../util/routeUtil'
import SeriesMobileSubMenu from '../menu/SeriesMobileSubMenu'
import SeriesStatus from './SeriesStatus'
import ThreeSportRaceInfo from './ThreeSportRaceInfo'
import ThreeSportDesktopResults from './ThreeSportDesktopResults'
import ThreeSportMobileResults from './ThreeSportMobileResults'
import NordicDesktopResults from './NordicDesktopResults'
import ResultsWithShots from './ResultsWithShots'
import NordicMobileResults from './NordicMobileResults'
import EuropeanDesktopResults from './EuropeanDesktopResults'
import EuropeanMobileResults from './EuropeanMobileResults'
import ShootingDesktopResults from './ShootingDesktopResults'
import ShootingMobileResults from './ShootingMobileResults'
import Button from '../../common/Button'
import useLayout from '../../util/useLayout'
import useRaceData from '../../util/useRaceData'
import IncompletePage from '../../common/IncompletePage'
import useDataReloading from '../../util/useDataReloading'
import { useResultRotation } from '../result-rotation/useResultRotation'
import { formatTodaysTime } from '../../util/timeUtil'

export default function SeriesResultsPage({ setSelectedPage }) {
  const { t } = useTranslation()
  const seriesId = parseInt(useParams().seriesId)
  const [allCompetitors, setAllCompetitors] = useState(false)
  const { mobile } = useLayout()
  const queryParams = allCompetitors ? '?all_competitors=true' : ''
  const buildApiPath = useCallback(raceId => {
    return `/api/v2/public/races/${raceId}/series/${seriesId}${queryParams}`
  }, [seriesId, queryParams])
  const { error, fetching, race, raceData: series, reloadDataRef } = useRaceData(buildApiPath)

  const titleSeries = (series?.id === seriesId && series) || (race && race.series.find(s => s.id === seriesId))
  const titleSuffix = useMemo(() => {
    if (!titleSeries || !race) return
    if (!titleSeries.competitors) return t('results')
    const competitors = titleSeries.competitors.filter(c => !c.onlyRifle)
    if (!competitors.length) return t('noCompetitors')
    if (!titleSeries.started) return t('seriesNotStarted')
    const suffix = allCompetitors ? ` - ${t('allCompetitors')}` : ''
    if (titleSeries.finished || race.finished) return `${t('results')}${suffix}`
    const maxTime = max(titleSeries.competitors.map(c => parseISO(c.updatedAt)))
    return `${t('resultsInProgress', { time: formatTodaysTime(maxTime) })}`
  }, [allCompetitors, race, t, titleSeries])

  const title = titleSeries ? `${titleSeries.name} - ${titleSuffix}` : t('results')
  useTitle(race && `${race.name} - ${title}`)
  useEffect(() => setSelectedPage(pages.results), [setSelectedPage])

  useDataReloading('SeriesChannel', 'series_id', seriesId, reloadDataRef)

  const toggleAllCompetitors = useCallback(() => setAllCompetitors(ac => !ac), [])

  const { started: resultRotationStarted, remainingSeconds } = useResultRotation()

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={title} />
  }

  const hasUnofficialCompetitors = race.unofficialsConfigurable && !!series.competitors.find(c => c.unofficial)
  const { european, nordic, shooting, shootingSimple } = race.sport
  return (
    <>
      <h2>
        {title}
        {resultRotationStarted && remainingSeconds && ` (${remainingSeconds})`}
      </h2>
      <SeriesStatus race={race} series={series}>
        {!shooting && <ThreeSportRaceInfo race={race} series={series} />}
        {shooting && (
          <ResultsWithShots competitors={series.competitors}>
            {nordic && !mobile && <NordicDesktopResults race={race} series={series} />}
            {nordic && mobile && <NordicMobileResults race={race} series={series} />}
            {european && !mobile && <EuropeanDesktopResults race={race} series={series} />}
            {european && mobile && <EuropeanMobileResults race={race} series={series} />}
            {shootingSimple && !mobile && <ShootingDesktopResults race={race} series={series} />}
            {shootingSimple && mobile && <ShootingMobileResults race={race} series={series} />}
          </ResultsWithShots>
        )}
        {!shooting && !mobile && (
          <ThreeSportDesktopResults race={race} series={series} setAllCompetitors={setAllCompetitors} />
        )}
        {!shooting && mobile && <ThreeSportMobileResults race={race} series={series} />}
        <div className="buttons">
          {hasUnofficialCompetitors && (
            <Button onClick={toggleAllCompetitors} id="all_competitors_button">
              {t(allCompetitors ? 'showOfficialResults' : 'showUnofficialResults')}
            </Button>
          )}
          <Button href={`${buildSeriesResultsPath(race.id, series.id)}.pdf${queryParams}`} type="pdf">
            {t('downloadResultsPdf')}
          </Button>
        </div>
      </SeriesStatus>
      <SeriesMobileSubMenu race={race} currentSeriesId={series.id} buildSeriesPath={buildSeriesResultsPath} />
      <div className="buttons buttons--nav">
        <Button to={buildRacePath(race.id)} type="back">{t('backToPage', { pageName: race.name })}</Button>
        {race.sport.startList && (
          <Button to={buildSeriesStartListPath(race.id, series.id)}>{t('startList')}</Button>
        )}
      </div>
    </>
  )
}
