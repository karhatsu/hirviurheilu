import useCompetitorSaving from '../competitors/useCompetitorSaving'
import { useCallback, useMemo, useRef, useState } from 'react'
import Select from '../../common/form/Select'
import { findSeriesById } from '../../util/seriesUtil'
import { competitorsOnlyToAgeGroups } from '../results/resultUtil'
import Button from '../../common/Button'
import useTranslation from '../../util/useTranslation'
import { resolveClubTitle } from '../../util/clubUtil'
import Message from '../../common/Message'

const fields = [
  { key: 'number', number: true },
  { key: 'startTime' },
  { key: 'firstName' },
  { key: 'lastName' },
  { key: 'seriesId', number: true },
  { key: 'ageGroupId', number: true },
]

const CompetitorRow = ({ race, availableSeries, competitor: initialCompetitor, onSave }) => {
  const { t } = useTranslation()
  const initialClubName = useRef(race.clubs.find((c) => c.id === initialCompetitor.clubId)?.name || '')
  const [clubName, setClubName] = useState(initialClubName.current)

  const isEditing = !!initialCompetitor.id

  const buildBody = useCallback((_, data) => ({ clubName, competitor: data }), [clubName])

  const handleSave = useCallback(
    (competitor) => {
      if (!isEditing) setClubName('')
      onSave(competitor, clubName)
    },
    [isEditing, onSave, clubName],
  )

  const { changed, changeValue, data, errors, onChange, onSubmit, saved, saving } = useCompetitorSaving(
    race.id,
    initialCompetitor,
    fields,
    buildBody,
    handleSave,
  )

  const series = useMemo(() => findSeriesById(availableSeries, data.seriesId), [availableSeries, data.seriesId])

  const handleSeriesChange = useCallback(
    (event) => {
      onChange('seriesId')(event)
      changeValue('ageGroupId', '')
    },
    [onChange, changeValue],
  )

  const inputId = useCallback((field) => `competitor_${initialCompetitor.id || 'new'}_${field}`, [initialCompetitor])

  const canSubmit =
    (changed || clubName !== initialClubName.current) &&
    clubName &&
    !saving &&
    !fields.find((f) => f.key !== 'ageGroupId' && !data[f.key])

  return (
    <div className="form__horizontal-fields competitor_row">
      <div className="form__field form__field--sm">
        <input
          id={inputId('number')}
          value={data.number}
          onChange={onChange('number')}
          type="number"
          min={0}
          step={1}
        />
      </div>
      <div className="form__field form__field--sm">
        <input
          id={inputId('startTime')}
          value={data.startTime}
          onChange={onChange('startTime')}
          placeholder="HH:MM:SS"
        />
      </div>
      <div className="form__field form__field--sm">
        <input
          id={inputId('firstName')}
          value={data.firstName}
          onChange={onChange('firstName')}
          placeholder={t('firstName')}
        />
      </div>
      <div className="form__field form__field--md">
        <input
          id={inputId('lastName')}
          value={data.lastName}
          onChange={onChange('lastName')}
          placeholder={t('lastName')}
        />
      </div>
      <div className="form__field form__field--md">
        <input
          id={inputId('clubName')}
          value={clubName}
          onChange={(e) => setClubName(e.target.value)}
          placeholder={resolveClubTitle(t, race.clubLevel)}
        />
      </div>
      <div className="form__field">
        <Select id={inputId('seriesId')} items={availableSeries} onChange={handleSeriesChange} value={data.seriesId} />
      </div>
      {series.ageGroups.length > 0 && (
        <div className="form__field">
          <Select
            id={inputId('ageGroupId')}
            items={series.ageGroups}
            onChange={onChange('ageGroupId')}
            promptLabel={competitorsOnlyToAgeGroups(series) ? undefined : series.name}
            promptValue={competitorsOnlyToAgeGroups(series) ? undefined : ''}
            value={data.ageGroupId}
          />
        </div>
      )}
      <div className="form__buttons">
        <Button type="primary" disabled={!canSubmit} onClick={onSubmit} id={inputId('save')}>
          {t(initialCompetitor.id ? 'save' : 'addNew')}
        </Button>
      </div>
      {errors && (
        <div className="form__field">
          <Message inline={true} type="error">
            {errors.join(' .')}.
          </Message>
        </div>
      )}
      {saved && !changed && (
        <div className="form__field">
          <Message inline={true} type="success">
            {t(isEditing ? 'saved' : 'added')}
          </Message>
        </div>
      )}
    </div>
  )
}

export default CompetitorRow
