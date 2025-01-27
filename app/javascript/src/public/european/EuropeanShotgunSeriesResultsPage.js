import React, { useCallback, useEffect } from 'react'
import useMenu, { pages } from '../../util/useMenu'
import useLayout from '../../util/useLayout'
import useTitle from '../../util/useTitle'
import useTranslation from '../../util/useTranslation'
import { useParams } from 'react-router'
import SeriesStatus from '../series-results/SeriesStatus'
import ResultsWithShots from '../series-results/ResultsWithShots'
import EuropeanShotgunDesktopResults from './EuropeanShotgunDesktopResults'
import Button from '../../common/Button'
import { buildRacePath, buildSeriesShotgunsResultsPath } from '../../util/routeUtil'
import EuropeanShotgunMobileResults from './EuropeanShotgunMobileResults'
import SeriesMobileSubMenu from '../menu/SeriesMobileSubMenu'
import useRaceData from '../../util/useRaceData'
import IncompletePage from '../../common/IncompletePage'
import useDataReloading from '../../util/useDataReloading'

export default function EuropeanShotgunSeriesResultsPage() {
  const { t } = useTranslation()
  const { setSelectedPage } = useMenu()
  const { seriesId } = useParams()
  const { mobile } = useLayout()
  const buildApiPath = useCallback(raceId => `/api/v2/public/races/${raceId}/series/${seriesId}/shotguns`, [seriesId])
  const { error, fetching, race, raceData: series, reloadDataRef } = useRaceData(buildApiPath)

  useTitle(race && series && [t('european_shotgun'), series.name, race.name, t(`sport_${race.sportKey}`)])
  useEffect(() => setSelectedPage(pages.europeanShotgun), [setSelectedPage])

  useDataReloading('SeriesChannel', 'series_id', seriesId, reloadDataRef)

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={t('european_shotgun')} />
  }

  return (
    <>
      <h2>{t('european_shotgun')} - {series.name}</h2>
      <SeriesStatus race={race} series={series}>
        <ResultsWithShots competitors={series.competitors}>
          {!mobile && <EuropeanShotgunDesktopResults race={race} competitors={series.competitors} />}
          {mobile && <EuropeanShotgunMobileResults competitors={series.competitors} />}
          <div className="buttons">
            <Button href={`${buildSeriesShotgunsResultsPath(race.id, series.id)}.pdf`} type="pdf">
              {t('downloadResultsPdf')}
            </Button>
          </div>
        </ResultsWithShots>
      </SeriesStatus>
      <SeriesMobileSubMenu race={race} currentSeriesId={series.id} buildSeriesPath={buildSeriesShotgunsResultsPath} />
      <div className="buttons buttons--nav">
        <Button to={buildRacePath(race.id)} type="back">{t('backToPage', { pageName: race.name })}</Button>
      </div>
    </>
  )
}
