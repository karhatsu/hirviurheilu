import React, { useEffect, useState } from 'react'
import { pages } from '../menu/DesktopSecondLevelMenu'
import { useRace } from '../../util/useRace'
import useLayout from '../../util/useLayout'
import useTitle from '../../util/useTitle'
import useTranslation from '../../util/useTranslation'
import { useParams } from 'react-router-dom'
import Message from '../../common/Message'
import Spinner from '../../common/Spinner'
import { get } from '../../util/apiClient'
import SeriesStatus from '../series-results/SeriesStatus'
import ResultsWithShots from '../series-results/ResultsWithShots'
import EuropeanRifleDesktopResults from './EuropeanRifleDesktopResults'
import Button from '../../common/Button'
import { buildRacePath, buildSeriesRifleResultsPath } from '../../util/routeUtil'
import EuropeanRifleMobileResults from './EuropeanRifleMobileResults'
import SeriesMobileSubMenu from '../menu/SeriesMobileSubMenu'

export default function EuropeanRifleResultsPage({ setSelectedPage }) {
  const { t } = useTranslation()
  const { seriesId } = useParams()
  const [error, setError] = useState()
  const [series, setSeries] = useState()
  const { race } = useRace()
  const { mobile } = useLayout()

  useTitle(race && series && `${race.name} - ${series.name} - ${t('rifle')}`)
  useEffect(() => setSelectedPage(pages.europeanRifle), [setSelectedPage])

  useEffect(() => {
    if (race) {
      const path = `/api/v2/public/races/${race.id}/series/${seriesId}/rifle`
      get(path, (err, data) => {
        if (err) return setError(err)
        setSeries(data)
      })
    }
  }, [race, seriesId])

  if (error) return <Message type="error">{error}</Message>
  if (!race || !series || (series && series.id !== parseInt(seriesId))) return <Spinner />

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
