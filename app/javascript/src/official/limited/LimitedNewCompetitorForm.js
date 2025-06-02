import { useCallback, useMemo, useState } from 'react'
import useTranslation from '../../util/useTranslation'
import FormErrors from '../../common/form/FormErrors'
import useCompetitorSaving from '../competitors/useCompetitorSaving'
import Button from '../../common/Button'
import FormField from '../../common/form/FormField'
import Select from '../../common/form/Select'
import ClubSelect from '../clubs/ClubSelect'
import { competitorsOnlyToAgeGroups } from '../results/resultUtil'
import { findClubById, resolveClubTitle } from '../../util/clubUtil'
import { findSeriesById } from '../../util/seriesUtil'
import { renderTeamNameHelpDialog, teamNameHelpDialogId } from '../competitors/CompetitorForm'
import useAppData from '../../util/useAppData'
import { buildLimitedOfficialCompetitorsPath } from '../../util/routeUtil'

const fields = [
  { key: 'seriesId', number: true },
  { key: 'ageGroupId', number: true },
  { key: 'firstName' },
  { key: 'lastName' },
  { key: 'clubId', number: true },
  { key: 'teamName' },
]

const LimitedNewCompetitorForm = ({ race, initialCompetitor, onSave }) => {
  const { t } = useTranslation()
  const { userRaceRight } = useAppData()

  const [clubName, setClubName] = useState(initialCompetitor.club?.name || '')

  const buildBody = useCallback((_, data) => ({ clubName, competitor: { ...data } }), [clubName])

  const handleSave = useCallback(
    (competitor) => {
      setClubName('')
      onSave(competitor)
    },
    [onSave],
  )

  const { changeValue, data, errors, onChange, onSubmit, saving } = useCompetitorSaving(
    race.id,
    initialCompetitor,
    fields,
    buildBody,
    handleSave,
    true,
  )

  const series = useMemo(() => {
    return data.seriesId ? findSeriesById(race.series, data.seriesId) : race.series[0]
  }, [race.series, data.seriesId])

  const handleSeriesChange = useCallback(
    (event) => {
      onChange('seriesId')(event)
      changeValue('ageGroupId', '')
    },
    [onChange, changeValue],
  )

  const onSelectClub = useCallback(
    (id, name) => {
      changeValue('clubId', id)
      setClubName(name)
    },
    [changeValue],
  )

  const renderClub = () => {
    if (userRaceRight.clubId) {
      return findClubById(race.clubs, userRaceRight.clubId).name
    }
    if (!userRaceRight.newClubs) {
      return (
        <Select
          id="clubId"
          items={race.clubs}
          value={data.clubId}
          onChange={onChange('clubId')}
          promptLabel={`Valitse ${resolveClubTitle(t, race.clubLevel).toLowerCase()}`}
          promptValue=""
        />
      )
    }
    return (
      <ClubSelect
        competitorId={initialCompetitor.id}
        clubs={race.clubs}
        clubName={clubName}
        clubLevel={race.clubLevel}
        onSelect={onSelectClub}
      />
    )
  }

  const ageGroupLabel = t(race.sport.shooting ? 'ageGroupShooting' : 'ageGroup')
  const promptAgeGroup = !competitorsOnlyToAgeGroups(series)
  const clubLabel = resolveClubTitle(t, race.clubLevel)
  return (
    <form className="form" onSubmit={onSubmit}>
      <FormErrors errors={errors} />
      <FormField id="seriesId" labelId="series" size="md">
        <Select
          id="seriesId"
          items={race.series}
          onChange={handleSeriesChange}
          value={data.seriesId}
          promptLabel="Valitse sarja"
          promptValue=""
        />
      </FormField>
      {series.ageGroups.length > 0 && (
        <FormField id="ageGroupId" label={ageGroupLabel} size="md">
          <Select
            id="ageGroupId"
            items={series.ageGroups}
            onChange={onChange('ageGroupId')}
            promptLabel={promptAgeGroup ? series.name : undefined}
            promptValue={promptAgeGroup ? '' : undefined}
            value={data.ageGroupId}
          />
        </FormField>
      )}
      <FormField id="firstName">
        <input id="firstName" value={data.firstName || ''} onChange={onChange('firstName')} />
      </FormField>
      <FormField id="lastName">
        <input id="lastName" value={data.lastName || ''} onChange={onChange('lastName')} />
      </FormField>
      <FormField id="clubId" label={clubLabel} size="lg">
        {renderClub()}
      </FormField>
      {race.hasTeamCompetitionsWithTeamNames && (
        <FormField id="teamName" labelId="team" helpDialogId={teamNameHelpDialogId}>
          <input id="teamName" value={data.teamName || ''} onChange={onChange('teamName')} />
          {renderTeamNameHelpDialog()}
        </FormField>
      )}
      <div className="form__buttons">
        <Button submit={true} type="primary" disabled={saving}>
          {t('save')}
        </Button>
        {initialCompetitor.id && <Button to={buildLimitedOfficialCompetitorsPath(race.id)}>{t('cancel')}</Button>}
      </div>
    </form>
  )
}

export default LimitedNewCompetitorForm
