import React from 'react'
import format from 'date-fns/format'
import isAfter from 'date-fns/isAfter'
import isBefore from 'date-fns/isBefore'
import parse from 'date-fns/parse'
import parseISO from 'date-fns/parseISO'
import useTranslation from '../../util/useTranslation'
import {
  buildFinalRoundBatchesPath,
  buildNordicResultsPath,
  buildQualificationRoundBatchesPath,
  buildSeriesResultsPath,
  buildSeriesRifleResultsPath,
  buildSeriesStartListPath,
} from '../../util/routeUtil'
import ClubSelect from './ClubSelect'
import BatchListPdfForm from './BatchListPdfForm'
import Button from '../../common/Button'
import Message from '../../common/Message'

export default function RaceSeries({ race }) {
  const { t } = useTranslation()
  const { clubLevel, clubs, finished, series, sport, startDate, startTime, relays } = race
  if (!series.length && relays.length) return null
  const infos = []
  if (!series.length && !relays.length) {
    infos.push(t('raceWithoutSeries'))
  }
  if (isAfter(parseISO(startDate), new Date())) {
    infos.push(t('raceBeginsIn', { distanceInTime: race.startDateDistanceInWords }))
  }
  if (startTime && !finished && isBefore(new Date(), new Date(startDate))) {
    const key = isAfter(new Date(), parseISO(startDate)) ? 'raceStarted' : 'raceStarts'
    infos.push(t(key, { time: format(parse(startTime, 'HH:mm:ss', new Date()), 'HH:mm') }))
  }
  return (
    <>
      <h2>{t(sport.shooting ? 'results' : 'personalCompetitions')}</h2>
      {infos.length > 0 && <Message type="info">{infos.join('. ')}.</Message>}
      <div className="buttons" id="series-links">
        {series.map(s => {
          const { id, name, started, startTime } = s
          if (!started && sport.startList) {
            const linkText = startTime ? `${name} (${format(parseISO(startTime), 'HH:mm')})` : name
            return <Button key={id} to={buildSeriesStartListPath(race.id, id)}>{linkText}</Button>
          } else {
            const to = buildSeriesResultsPath(race.id, id)
            return <Button key={id} to={to} type="primary">{name}</Button>
          }
        })}
      </div>
      {sport.nordic && (
        <div className="buttons">
          {['trap', 'shotgun', 'rifle_standing', 'rifle_moving'].map(subSport => {
            return (
              <Button key={subSport} href={buildNordicResultsPath(race.id, subSport)} type="primary">
                {t(`nordic_${subSport}`)}
              </Button>
            )
          })}
        </div>
      )}
      {sport.european && (
        <div className="buttons">
          {series.map(s => {
            const { id, name } = s
            const linkText = `${t('rifle')} ${name}`
            return <Button key={id} href={buildSeriesRifleResultsPath(race.id, id)} type="primary">{linkText}</Button>
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
                    <Button submit={true} type="pdf">{t('downloadStartTimes')}</Button>
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
