import React, { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import format from 'date-fns/format'
import { get } from '../util/apiClient'
import DesktopStartList from './DesktopStartList'
import MobileStartList from './MobileStartList'
import SeriesMobileSubMenu from './SeriesMobileSubMenu'
import useTranslation from '../util/useTranslation'
import Spinner from '../spinner/Spinner'
import { buildSeriesStartListLink } from '../util/routeUtil'
import useTitle from '../util/useTitle'

export default function StartList() {
  const { raceId, seriesId } = useParams()
  const [error, setError] = useState()
  const [race, setRace] = useState()
  const [series, setSeries] = useState()
  const { t } = useTranslation()
  useTitle(race && series && `${race.name} - ${series.name} - ${t('startList')}`)

  useEffect(() => {
    get(`/api/v2/public/races/${raceId}?no_competitors=true`, (err, data) => {
      if (err) return setError(err)
      setRace(data)
    })
    get(`/api/v2/public/races/${raceId}/series/${seriesId}/start_list`, (err, data) => {
      if (err) return setError(err)
      setSeries(data)
    })
  }, [raceId, seriesId])

  if (error) return <div className="message message--error">{error}</div>
  if (!(race && series) && !error) return <Spinner />

  const { competitors, id, name, started, startTime } = series
  return (
    <>
      <h2>{name} - {t('startList')}</h2>
      {startTime && !started && (
        <div className="message message--info">
          {t('seriesStartTime')}: {format(new Date(startTime), 'dd.MM.yyyy hh:mm')}
        </div>
      )}
      {competitors.length > 0 && (
        <>
          <DesktopStartList competitors={competitors} race={race} />
          <MobileStartList competitors={competitors} race={race} />
          <a href={`/races/${raceId}/series/${seriesId}/start_list.pdf`} className="button button--pdf">
            {t('downloadStartListPdf')}
          </a>
        </>
      )}
      {!competitors.length && <div className="message message--info">{t('noCompetitorsOrStartTimes')}</div>}
      <SeriesMobileSubMenu allSeries={race.series} buildSeriesLink={buildSeriesStartListLink()} currentSeriesId={id} />
      <div className="buttons buttons--nav">
        <a href={`/races/${raceId}`} className="button button--back">{t('backToPage', { pageName: race.name })}</a>
        <a href={`/races/${raceId}/series/${seriesId}`} className="button">{t('results')}</a>
      </div>
    </>
  )
}
