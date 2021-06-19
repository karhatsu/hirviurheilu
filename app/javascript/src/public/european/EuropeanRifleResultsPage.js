import React, { useCallback, useEffect } from 'react'
import { pages } from '../menu/DesktopSecondLevelMenu'
import useLayout from '../../util/useLayout'
import useTitle from '../../util/useTitle'
import useTranslation from '../../util/useTranslation'
import { useParams } from 'react-router-dom'
import SeriesStatus from '../series-results/SeriesStatus'
import ResultsWithShots from '../series-results/ResultsWithShots'
import EuropeanRifleDesktopResults from './EuropeanRifleDesktopResults'
import Button from '../../common/Button'
import { buildRacePath, buildSeriesRifleResultsPath } from '../../util/routeUtil'
import EuropeanRifleMobileResults from './EuropeanRifleMobileResults'
import SeriesMobileSubMenu from '../menu/SeriesMobileSubMenu'
import useRaceData from '../../util/useRaceData'
import IncompletePage from '../../common/IncompletePage'

export default function EuropeanRifleResultsPage({ setSelectedPage }) {
  const { t } = useTranslation()
  const { seriesId } = useParams()
  const { mobile } = useLayout()
  const buildApiPath = useCallback(raceId => `/api/v2/public/races/${raceId}/series/${seriesId}/rifle`, [seriesId])
  const { error, fetching, race, raceData: series } = useRaceData(buildApiPath)

  useTitle(race && series && `${race.name} - ${series.name} - ${t('rifle')}`)
  useEffect(() => setSelectedPage(pages.europeanRifle), [setSelectedPage])

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={t('rifle')} />
  }

  return (
    <>
      <h2>{t('rifle')} - {series.name}</h2>
      <SeriesStatus race={race} series={series}>
        <ResultsWithShots competitors={series.competitors}>
          {!mobile && <EuropeanRifleDesktopResults race={race} series={series} />}
          {mobile && <EuropeanRifleMobileResults race={race} series={series} />}
          <div className="buttons">
            <Button href={`${buildSeriesRifleResultsPath(race.id, series.id)}.pdf`} type="pdf">
              {t('downloadResultsPdf')}
            </Button>
          </div>
        </ResultsWithShots>
      </SeriesStatus>
      <SeriesMobileSubMenu race={race} currentSeriesId={series.id} buildSeriesPath={buildSeriesRifleResultsPath} />
      <div className="buttons buttons--nav">
        <Button to={buildRacePath(race.id)} type="back">{t('backToPage', { pageName: race.name })}</Button>
      </div>
    </>
  )
}
