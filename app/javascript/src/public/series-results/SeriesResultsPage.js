import React, { useCallback, useEffect, useMemo, useState } from 'react'
import format from 'date-fns/format'
import max from 'date-fns/max'
import parseISO from 'date-fns/parseISO'
import { useRace } from '../../util/useRace'
import useTitle from '../../util/useTitle'
import { useParams } from 'react-router-dom'
import { get } from '../../util/apiClient'
import Spinner from '../../common/Spinner'
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

export default function SeriesResultsPage({ setSelectedPage }) {
  const { t } = useTranslation()
  const { seriesId } = useParams()
  const [error, setError] = useState()
  const [series, setSeries] = useState()
  const [allCompetitors, setAllCompetitors] = useState(false)
  const { race } = useRace()

  const titleSuffix = useMemo(() => {
    if (!series || !race) return
    const competitors = series.competitors.filter(c => !c.onlyRifle)
    if (!competitors.length) return t('noCompetitors')
    if (!series.started) return t('seriesNotStarted')
    const suffix = allCompetitors ? ` - ${t('allCompetitors')}` : ''
    if (series.finished || race.finished) return `${t('results')}${suffix}`
    const maxTime = max(series.competitors.map(c => parseISO(c.updatedAt)))
    return `${t('resultsInProgress', { time: format(maxTime, 'dd.MM.yyyy HH:mm') })}`
  }, [allCompetitors, race, t, series])

  const title = series && `${series.name} - ${titleSuffix}`
  useTitle(race && `${race.name} - ${title}`)
  useEffect(() => setSelectedPage(pages.results), [setSelectedPage])

  const queryParams = allCompetitors ? '?all_competitors=true' : ''
  useEffect(() => {
    if (race) {
      const path = `/api/v2/public/races/${race.id}/series/${seriesId}${queryParams}`
      get(path, (err, data) => {
        if (err) return setError(err)
        setSeries(data)
      })
    }
  }, [race, seriesId, queryParams])

  const toggleAllCompetitors = useCallback(() => setAllCompetitors(ac => !ac), [])

  if (error) return <div className="message message--error">{error}</div>
  if (!race || !series || (series && series.id !== parseInt(seriesId))) return <Spinner />

  const hasUnofficialCompetitors = race.unofficialsConfigurable && !!series.competitors.find(c => c.unofficial)
  const { european, nordic, shooting, shootingSimple } = race.sport
  return (
    <>
      <h2>{title}</h2>
      <SeriesStatus race={race} series={series}>
        {!shooting && <ThreeSportRaceInfo race={race} series={series} />}
        {shooting && (
          <ResultsWithShots series={series}>
            {nordic && <NordicDesktopResults race={race} series={series} />}
            {nordic && <NordicMobileResults race={race} series={series} />}
            {european && <EuropeanDesktopResults race={race} series={series} />}
            {european && <EuropeanMobileResults race={race} series={series} />}
            {shootingSimple && <ShootingDesktopResults race={race} series={series} />}
            {shootingSimple && <ShootingMobileResults race={race} series={series} />}
          </ResultsWithShots>
        )}
        {!shooting && <ThreeSportDesktopResults race={race} series={series} setAllCompetitors={setAllCompetitors} />}
        {!shooting && <ThreeSportMobileResults race={race} series={series} />}
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
