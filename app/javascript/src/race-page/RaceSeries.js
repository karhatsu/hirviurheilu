import React from 'react'
import { Link } from 'react-router-dom'
import format from 'date-fns/format'
import isAfter from 'date-fns/isAfter'
import isBefore from 'date-fns/isBefore'
import formatDistanceToNow from 'date-fns/formatDistanceToNow'
import parse from 'date-fns/parse'
import parseISO from 'date-fns/parseISO'
import useTranslation from '../util/useTranslation'
import {
  buildFinalRoundBatchesPath,
  buildNordicResultsPath,
  buildQualificationRoundBatchesPath,
  buildSeriesResultsPath,
  buildSeriesRifleResultsPath,
  buildSeriesStartListPath,
} from '../util/routeUtil'
import ClubSelect from './ClubSelect'
import BatchListPdfForm from './BatchListPdfForm'

export default function RaceSeries({ race }) {
  const { t } = useTranslation()
  const { clubLevel, clubs, finished, series, sport, startDate, startTime, relays } = race
  if (!series.length && relays.length) return null
  const infos = []
  if (!series.length && !relays.length) {
    infos.push(t('raceWithoutSeries'))
  }
  if (isAfter(parseISO(startDate), new Date())) {
    infos.push(t('raceBeginsIn', { distanceInTime: formatDistanceToNow(new Date(startDate)) }))
  }
  if (startTime && !finished && isBefore(new Date(), new Date(startDate))) {
    const key = isAfter(new Date(), parseISO(startDate)) ? 'raceStarted' : 'raceStarts'
    infos.push(t(key, { time: format(parse(startTime, 'HH:mm:ss', new Date()), 'HH:mm') }))
  }
  return (
    <>
      <h2>{t(sport.shooting ? 'results' : 'personalCompetitions')}</h2>
      {infos.length > 0 && <div className="message message--info">{infos.join('. ')}.</div>}
      <div className="buttons" id="series-links">
        {series.map(s => {
          const { id, name, started, startTime } = s
          if (!started && sport.startList) {
            const linkText = startTime ? `${name} (${format(parseISO(startTime), 'HH:mm')})` : name
            return <Link key={id} to={buildSeriesStartListPath(race.id, id)} className="button">{linkText}</Link>
          } else {
            return <a key={id} href={buildSeriesResultsPath(race.id, id)} className="button button--primary">{name}</a>
          }
        })}
      </div>
      {sport.nordic && (
        <div className="buttons">
          {['trap', 'shotgun', 'rifle_standing', 'rifle_moving'].map(subSport => {
            return (
              <a
                key={subSport}
                href={buildNordicResultsPath(race.id, subSport)}
                className="button button--primary"
              >{t(`nordic_${subSport}`)}</a>
            )
          })}
        </div>
      )}
      {sport.european && (
        <div className="buttons">
          {series.map(s => {
            const { id, name } = s
            const linkText = `${t('rifle')} ${name}`
            return (
              <a key={id} href={buildSeriesRifleResultsPath(race.id, id)} className="button button--primary">
                {linkText}
              </a>
            )
          })}
        </div>
      )}
      {!finished && series.find(s => s.competitorsCount > 0) && (
        <div className="results--desktop">
          {sport.startList && (
            <>
              <h3>{t('allSeriesStartTimesPdf')}</h3>
              <form action={`/races/${race.id}/start_lists.pdf`} method="GET" className="form">
                <div className="form__horizontal-fields">
                  <div className="form__field">
                    <ClubSelect clubLevel={clubLevel} clubs={clubs} />
                  </div>
                  <div className="form__buttons">
                    <input type="submit" className="button button--pdf" value={t('downloadStartTimes')} />
                  </div>
                </div>
              </form>
            </>
          )}
          {race.qualificationRoundBatches.length > 0 && (
            <BatchListPdfForm
              path={buildQualificationRoundBatchesPath(race.id)}
              race={race}
              title={t(sport.oneBatchList ? 'batchLists' : 'qualificationRoundBatchLists')}
            />
          )}
          {race.finalRoundBatches.length > 0 && (
            <BatchListPdfForm
              path={buildFinalRoundBatchesPath(race.id)}
              race={race}
              title={t('finalRoundBatchLists')}
            />
          )}
        </div>
      )}
    </>
  )
}
