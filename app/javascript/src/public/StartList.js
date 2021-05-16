import React, { useCallback, useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import format from 'date-fns/format'
import { get } from '../util/apiClient'
import DesktopStartList from './DesktopStartList'
import MobileStartList from './MobileStartList'
import SeriesMobileSubMenu from './SeriesMobileSubMenu'

export default function StartList() {
  const { raceId, seriesId } = useParams()
  const [error, setError] = useState()
  const [race, setRace] = useState()
  const [series, setSeries] = useState()

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

  const buildSeriesLink = useCallback(id => `/races/${raceId}/series/${id}/start_list`, [raceId])

  if (error) return <div className="message message--error">{error}</div>
  if (!(race && series) && !error) return null

  const { competitors, id, name, started, startTime } = series
  return (
    <>
      <h2>{name} - Lähtölista</h2>
      {startTime && !started && (
        <div className="message message--info">
          Sarjan lähtöaika: {format(new Date(startTime), 'dd.MM.yyyy hh:mm')}
        </div>
      )}
      {competitors.length > 0 && (
        <>
          <DesktopStartList competitors={competitors} race={race} />
          <MobileStartList competitors={competitors} race={race} />
          <a href={`/races/${raceId}/series/${seriesId}/start_list.pdf`} className="button button--pdf">Lataa lähtölista pdf-tiedostona</a>
        </>
      )}
      {!competitors.length && (
        <div className="message message--info">
          Tähän sarjaan ei ole merkitty kilpailijoita tai heille ei ole määritetty vielä lähtöaikoja.
        </div>
      )}
      <SeriesMobileSubMenu allSeries={race.series} buildSeriesLink={buildSeriesLink} currentSeriesId={id} />
      <div className="buttons buttons--nav">
        <a href={`/races/${raceId}`} className="button button--back">Takaisin sivulle {race.name}</a>
        <a href={`/races/${raceId}/series/${seriesId}`} className="button">Tulokset</a>
      </div>
    </>
  )
}
