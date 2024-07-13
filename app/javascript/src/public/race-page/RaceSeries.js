import React from 'react'
import format from 'date-fns/format'
import isAfter from 'date-fns/isAfter'
import parse from 'date-fns/parse'
import parseISO from 'date-fns/parseISO'
import useTranslation from '../../util/useTranslation'
import {
  buildFinalRoundBatchesPath,
  buildNordicResultsPath,
  buildNordicSeriesResultsPath,
  buildQualificationRoundBatchesPath,
  buildRaceRifleResultsPath,
  buildRaceShotgunsResultsPath,
  buildRaceStartListsPdfPath,
  buildSeriesResultsPath,
  buildSeriesRifleResultsPath,
  buildSeriesShotgunsResultsPath,
  buildSeriesStartListPath,
} from '../../util/routeUtil'
import ClubSelect from './ClubSelect'
import BatchListPdfForm from './BatchListPdfForm'
import Button from '../../common/Button'
import Message from '../../common/Message'
import { formatTodaysTime } from '../../util/timeUtil'
import { raceEnums } from '../../util/enums'

const nordicSubSports = ['trap', 'shotgun', 'rifle_standing', 'rifle_moving']

const resultsKey = sport => {
  if (sport.european) return 'totalResults'
  if (sport.shooting) return 'results'
  return 'personalCompetitions'
}

export default function RaceSeries({ race }) {
  const { t } = useTranslation()
  const {
    clubLevel,
    clubs,
    finished,
    level,
    nordicSubResultsForSeries,
    series,
    showEuropeanShotgunResults,
    sport,
    startDateTime,
    startTime,
    relays,
  } = race
  if (!series.length && relays.length) return null
  const infos = []
  if (!series.length && !relays.length) {
    infos.push(t('raceWithoutSeries'))
  }
  if (startTime && !finished) {
    const key = isAfter(new Date(), new Date(startDateTime)) ? 'raceStarted' : 'raceStarts'
    infos.push(t(key, { time: format(parse(startTime, 'HH:mm:ss', new Date()), 'HH:mm') }))
  }
  const qrHidden = race.hideQualificationRoundBatches
  const frHidden = race.hideFinalRoundBatches
  return (
    <>
      <h2>{t(resultsKey(sport))}</h2>
      {infos.length > 0 && <Message type="info">{infos.join('. ')}.</Message>}
      <div className="buttons" id="series-links">
        {series.map(s => {
          const { id, name, started, startTime } = s
          if (!started && sport.startList) {
            const linkText = startTime ? `${name} (${formatTodaysTime(parseISO(startTime))})` : name
            return <Button key={id} to={buildSeriesStartListPath(race.id, id)}>{linkText}</Button>
          } else {
            const to = buildSeriesResultsPath(race.id, id)
            return <Button key={id} to={to} type="primary">{name}</Button>
          }
        })}
      </div>
      {sport.nordic && !nordicSubResultsForSeries && (
        <div className="buttons">
          {nordicSubSports.map(subSport => {
            return (
              <Button key={subSport} to={buildNordicResultsPath(race.id, subSport)} type="primary">
                {t(`nordic_${subSport}`)}
              </Button>
            )
          })}
        </div>
      )}
      {sport.nordic && nordicSubResultsForSeries && nordicSubSports.map(subSport => (
        <React.Fragment key={subSport}>
          <h2>{t(`nordic_${subSport}`)}</h2>
          <div className="buttons">
            {series.map(s => (
              <Button key={s.id} to={buildNordicSeriesResultsPath(race.id, s.id, subSport)} type="primary">
                {s.name}
              </Button>
            ))}
          </div>
        </React.Fragment>
      ))}
      {sport.european && (
        <>
          <h3>{t('european_rifle')}</h3>
          {level === raceEnums.level.international && (
            <Button to={buildRaceRifleResultsPath(race.id)} type="primary">{t('results')}</Button>
          )}
          {level !== raceEnums.level.international && (
            <div className="buttons" id="european_rifle_buttons">
              {series.map(s => {
                const { id, name } = s
                return <Button key={id} to={buildSeriesRifleResultsPath(race.id, id)} type="primary">{name}</Button>
              })}
            </div>
          )}
          {showEuropeanShotgunResults && (
            <>
              <h3>{t('european_shotgun')}</h3>
              {level === raceEnums.level.international && (
                <Button to={buildRaceShotgunsResultsPath(race.id)} type="primary">{t('results')}</Button>
              )}
              {level !== raceEnums.level.international && (
                <div className="buttons" id="european_shotgun_buttons">
                  {series.map(s => {
                    const { id, name } = s
                    return (
                      <Button key={id} to={buildSeriesShotgunsResultsPath(race.id, id)} type="primary">{name}</Button>
                    )
                  })}
                </div>
              )}
            </>
          )}
        </>
      )}
      {!finished && series.find(s => s.competitorsCount > 0) && (
        <div className="results--desktop">
          {sport.startList && (
            <>
              <h3>{t('allSeriesStartTimesPdf')}</h3>
              <form action={buildRaceStartListsPdfPath(race.id)} method="GET" className="form">
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
          {!qrHidden && race.qualificationRoundBatches.length > 0 && (
            <BatchListPdfForm
              path={buildQualificationRoundBatchesPath(race.id)}
              race={race}
              title={t(sport.oneBatchList ? 'batchList' : 'qualificationRoundBatchList')}
            />
          )}
          {!frHidden && race.finalRoundBatches.length > 0 && (
            <BatchListPdfForm
              path={buildFinalRoundBatchesPath(race.id)}
              race={race}
              title={t('finalRoundBatchList')}
            />
          )}
        </div>
      )}
    </>
  )
}
