import Button from '../../common/Button'
import { useResultRotation } from './useResultRotation'
import useTranslation from '../../util/useTranslation'
import Message from '../../common/Message'
import { competitorsCountLabel } from '../../util/competitorUtil'

export default function ResultRotationForm({ race }) {
  const { t } = useTranslation()
  const {
    autoScroll,
    changeAutoScroll,
    changeSeconds,
    changeSeriesId,
    changeTeamCompetitionId,
    seconds,
    minSeconds,
    seriesIds,
    start,
    teamCompetitionIds,
  } = useResultRotation()
  const disabled = (seriesIds.length + teamCompetitionIds.length) < 2 || seconds < minSeconds
  return (
    <>
      <Message type="info">{t('resultRotationInfo')}</Message>
      <h3>{t('seriesPlural')}</h3>
      {race.series.map(series => {
        const { id, name, competitorsCount } = series
        return (
          <div key={id} className="form__horizontal-fields">
            <div className="form__field">
              <input
                type="checkbox"
                id={`series_${id}`}
                checked={seriesIds.includes(id)}
                onChange={changeSeriesId(id)}
              />
              <label htmlFor={`series_${id}`}>{name} ({competitorsCountLabel(t, competitorsCount)})</label>
            </div>
          </div>
        )
      })}
      {race.teamCompetitions.length > 0 && (
        <>
          <h3>{t('teamCompetitions')}</h3>
          {race.teamCompetitions.map(tc => {
            const { id, name } = tc
            return (
              <div key={id} className="form__horizontal-fields">
                <div className="form__field">
                  <input
                    type="checkbox"
                    id={`series_${id}`}
                    checked={teamCompetitionIds.includes(id)}
                    onChange={changeTeamCompetitionId(id)}
                  />
                  <label htmlFor={`series_${id}`}>{name}</label>
                </div>
              </div>
            )
          })}
        </>
      )}
      <h3>{t('resultRotationSettings')}</h3>
      <div className="form__horizontal-fields">
        <div className="form__field">
          <input type="checkbox" id="autoScroll" checked={autoScroll} onChange={changeAutoScroll} />
          <label htmlFor="autoScroll">{t('resultRotationAutoScroll')}</label>
        </div>
      </div>
      <div className="form__field form__field--sm">
        <label htmlFor="seconds">{t('secondsPerPage')}{autoScroll ? ` (${t('atLeast')})` : ''}</label>
        <input type="number" value={seconds} id="seconds" onChange={changeSeconds} min={5} step={1} />
        <div className="form__field__info">min 5</div>
      </div>
      <div className="form__buttons">
        <Button onClick={start} type="primary" disabled={disabled}>{t('resultRotationStart')}</Button>
      </div>
    </>
  )
}
