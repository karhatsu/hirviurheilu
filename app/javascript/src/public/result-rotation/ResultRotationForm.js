import React from 'react'
import Button from '../../common/Button'
import { useResultRotation } from './useResultRotation'
import useTranslation from '../../util/useTranslation'
import Message from '../../common/Message'

export default function ResultRotationForm({ race }) {
  const { t } = useTranslation()
  const { changeSeconds, changeSeriesId, seconds, minSeconds, seriesIds, start } = useResultRotation()
  const messageSeconds = seconds >= minSeconds ? seconds : '?'
  const disabled = seriesIds.length < 2 || seconds < minSeconds
  return (
    <>
      <Message type="info">{t('resultRotationInfo', { seconds: messageSeconds })}</Message>
      <h3>{t('seriesPlural')}</h3>
      {race.series.map(series => {
        const { id, name } = series
        return (
          <div key={id} className="form__horizontal-fields">
            <div className="form__field">
              <input
                type="checkbox"
                id={`series_${id}`}
                checked={seriesIds.includes(id)}
                onChange={changeSeriesId(id)}
              />
              <label htmlFor={`series_${id}`}>{name}</label>
            </div>
          </div>
        )
      })}
      <h3>{t('secondsPerPage')}</h3>
      <div className="form__field form__field--sm">
        <input type="number" value={seconds} id="seconds" onChange={changeSeconds} />
        <div className="form__field__info">min 5</div>
      </div>
      <div className="form__buttons">
        <Button onClick={start} type="primary" disabled={disabled}>{t('resultRotationStart')}</Button>
      </div>
    </>
  )
}
