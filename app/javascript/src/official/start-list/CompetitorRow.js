import useCompetitorSaving from '../competitors/useCompetitorSaving'
import { useCallback, useMemo, useRef, useState } from 'react'
import Select from '../../common/form/Select'
import { findSeriesById } from '../../util/seriesUtil'
import { competitorsOnlyToAgeGroups } from '../results/resultUtil'
import Button from '../../common/Button'
import useTranslation from '../../util/useTranslation'
import Message from '../../common/Message'
import ClubSelect from '../clubs/ClubSelect'
import { findClubById } from '../../util/clubUtil'

const fields = [
  { key: 'number', number: true },
  { key: 'startTime' },
  { key: 'firstName' },
  { key: 'lastName' },
  { key: 'clubId', number: true },
  { key: 'seriesId', number: true },
  { key: 'ageGroupId', number: true },
]

const CompetitorRow = ({ race, availableSeries, competitor: initialCompetitor, onSave }) => {
  const { t } = useTranslation()
  const initialClubName = useRef(findClubById(race.clubs, initialCompetitor.clubId)?.name || '')
  const [clubName, setClubName] = useState(initialClubName.current)

  const isEditing = !!initialCompetitor.id

  const buildBody = useCallback((_, data) => ({ clubName, competitor: data }), [clubName])

  const handleSave = useCallback(
    (competitor) => {
      if (isEditing) {
        initialClubName.current = clubName
      } else {
        setClubName('')
      }
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

  const onSelectClub = useCallback(
    (id, name) => {
      changeValue('clubId', id)
      setClubName(name)
    },
    [changeValue],
  )

  const promptAgeGroup = !competitorsOnlyToAgeGroups(series) || (isEditing && !data.ageGroupId)

  const canSubmit =
    (changed || clubName !== initialClubName.current) &&
    clubName &&
    !saving &&
    !fields.find((f) => !['ageGroupId', 'clubId'].includes(f.key) && !data[f.key])

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
      <div className="form__field form__field--md form__field--with-dropdown">
        <ClubSelect
          competitorId={initialCompetitor.id}
          clubs={race.clubs}
          clubName={clubName}
          clubLevel={race.clubLevel}
          onSelect={onSelectClub}
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
            promptLabel={promptAgeGroup ? series.name : undefined}
            promptValue={promptAgeGroup ? '' : undefined}
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
