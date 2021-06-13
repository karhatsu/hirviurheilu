import React, { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import format from 'date-fns/format'
import { get } from '../../util/apiClient'
import DesktopStartList from './DesktopStartList'
import MobileStartList from './MobileStartList'
import SeriesMobileSubMenu from '../menu/SeriesMobileSubMenu'
import useTranslation from '../../util/useTranslation'
import Spinner from '../../common/Spinner'
import { buildRacePath, buildSeriesResultsPath, buildSeriesStartListPath } from '../../util/routeUtil'
import useTitle from '../../util/useTitle'
import { useRace } from '../../util/useRace'
import { pages } from '../menu/DesktopSecondLevelMenu'
import Button from '../../common/Button'

export default function StartListPage({ setSelectedPage }) {
  const { raceId, seriesId } = useParams()
  const [error, setError] = useState()
  const [series, setSeries] = useState()
  const { race } = useRace()
  const { t } = useTranslation()
  useTitle(race && series && `${race.name} - ${series.name} - ${t('startList')}`)
  useEffect(() => setSelectedPage(pages.startList), [setSelectedPage])

  useEffect(() => {
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
          <Button href={`/races/${raceId}/series/${seriesId}/start_list.pdf`} type="pdf">
            {t('downloadStartListPdf')}
          </Button>
        </>
      )}
      {!competitors.length && <div className="message message--info">{t('noCompetitorsOrStartTimes')}</div>}
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
