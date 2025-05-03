import { useCallback, useMemo, useRef, useState } from "react"
import isAfter from 'date-fns/isAfter'
import isToday from 'date-fns/isToday'
import FormField from "../../common/form/FormField"
import useCompetitorSaving from "./useCompetitorSaving"
import { resolveClubTitle } from "../../util/clubUtil"
import useTranslation from "../../util/useTranslation"
import Button from "../../common/Button"
import FormErrors from "../../common/form/FormErrors"
import Dialog from "../../common/form/Dialog"
import Select from "../../common/form/Select"
import { buildOfficialCompetitorEditPath, buildOfficialRaceQuickSavesPath } from "../../util/routeUtil"
import { findSeriesById } from "../../util/seriesUtil"

const teamNameHelpDialogId = 'team_name_help_dialog'

const renderTeamNameHelpDialog = () => (
  <Dialog id={teamNameHelpDialogId} title="Joukkueen nimi">
    Jos kilpailija osallistuu joukkuekilpailuun, jossa joukkueita ei muodosteta seuran nimen perusteella,
    syötä tähän kenttään kilpailijan joukkueen nimi. Muussa tapauksessa jätä kenttä tyhjäksi.
  </Dialog>
)

const fields = [
  { key: 'seriesId', number: true },
  { key: 'ageGroupId', number: true },
  { key: 'firstName' },
  { key: 'lastName' },
  { key: 'unofficial', checkbox: true },
  { key: 'clubId', number: true },
  { key: 'teamName' },
  { key: 'onlyRifle', checkbox: true },
  { key: 'number', number: true },
  { key: 'startTime' },
  { key: 'qualificationRoundHeatId', number: true },
  { key: 'qualificationRoundTrackPlace', number: true },
  { key: 'finalRoundHeatId', number: true },
  { key: 'finalRoundTrackPlace', number: true },
]

const competitorsOnlyToAgeGroups = series => series.name.match(/^S\d\d?$/)

const CompetitorForm = ({ race, competitor: initialCompetitor, onSeriesChange, onSave }) => {
  const { t } = useTranslation()
  const [clubName, setClubName] = useState('')
  const actionAfterSaveRef = useRef()

  const buildBody = useCallback((_, data) => {
    const series = findSeriesById(race.series, data.seriesId)
    return {
      competitor: {
        ...data,
        number: series.hasStartList || race.sport.shooting ? data.number : undefined,
        startTime: series.hasStartList ? data.startTime : undefined,
      },
      clubName,
    }
  }, [race, clubName])

  const handleSave = useCallback(competitor => {
    if (actionAfterSaveRef.current === 'toEdit') {
      window.location.href = buildOfficialCompetitorEditPath(race.id, competitor.seriesId, competitor.id)
    } else if (actionAfterSaveRef.current === 'toQuickSave') {
      window.location.href = buildOfficialRaceQuickSavesPath(race.id)
    } else {
      setClubName('')
      onSave(competitor)
    }
  }, [race, onSave])

  const { data, errors, onChange, onSubmit, saving }
    = useCompetitorSaving(race.id, initialCompetitor, fields, buildBody, handleSave)

  const handleSeriesChange = useCallback(event => {
    onChange('seriesId')(event)
    onSeriesChange(parseInt(event.target.value))
  }, [onChange, onSeriesChange])

  const series = useMemo(() => findSeriesById(race.series, data.seriesId), [race, data.seriesId])

  const submit = useCallback(action => event => {
    actionAfterSaveRef.current = action
    onSubmit(event)
  }, [onSubmit])

  const ageGroupLabel = t(race.sport.shooting ? 'ageGroupShooting' : 'ageGroup')
  const clubLabel = resolveClubTitle(t, race.clubLevel )
  return (
    <form className="form" onSubmit={onSubmit}>
      <FormErrors errors={errors} />
      <FormField id="seriesId" labelId="series" size="md">
        <Select id="seriesId" items={race.series} onChange={handleSeriesChange} value={data.seriesId} />
      </FormField>
      {series.ageGroups.length > 0 && (
        <FormField id="ageGroupId" label={ageGroupLabel} size="md">
          <Select
            id="ageGroupId"
            items={series.ageGroups}
            onChange={onChange('ageGroupId')}
            promptLabel={competitorsOnlyToAgeGroups(series) ? undefined : series.name}
            promptValue={competitorsOnlyToAgeGroups(series) ? undefined : ''}
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
      <FormField id="unofficial">
        <input id="unofficial" type="checkbox" checked={data.unofficial} onChange={onChange('unofficial')} />
      </FormField>
      <FormField id="clubId" label={clubLabel} size="lg">
        <div className="form__field__select-and-input">
          {race.clubs.length > 0 && (
            <Select
              id="clubId"
              items={race.clubs}
              onChange={onChange('clubId')}
              promptLabel={t('selectClubOrAddNew', { clubLabel: clubLabel.toLowerCase() })}
              promptValue=""
              value={data.clubId || ''}
            />
          )}
          {!data.clubId && (
            <input
              id="club_name"
              value={clubName}
              onChange={e => setClubName(e.target.value)}
              placeholder={t('newClub', { clubLabel: clubLabel.toLowerCase() })}
            />
          )}
        </div>
      </FormField>
      {race.hasTeamCompetitionsWithTeamNames && (
        <FormField id="teamName" labelId="team" helpDialogId={teamNameHelpDialogId}>
          <input id="teamName" value={data.teamName || ''} onChange={onChange('teamName')} />
          {renderTeamNameHelpDialog()}
        </FormField>
      )}
      {race.sport.european && (
        <FormField id="onlyRifle">
          <input id="onlyRifle" type="checkbox" checked={data.onlyRifle} onChange={onChange('onlyRifle')} />
        </FormField>
      )}
      {(race.sport.shooting || series.hasStartList) && (
        <FormField id="number" size="sm">
          <input id="number" type="number" min={0} value={data.number || ''} onChange={onChange('number')}/>
        </FormField>
      )}
      {!race.sport.shooting && series.hasStartList && (
        <FormField id="startTime" size="md">
          <input id="startTime" value={data.startTime || ''} onChange={onChange('startTime')} placeholder="HH:MM:SS" />
        </FormField>
      )}
      {race.sport.shooting && race.qualificationRoundHeats.length > 0 && (
        <>
          <FormField id="qualificationRoundHeatId" labelId="qualificationRoundHeat" size="sm">
            <Select
              id="qualificationRoundHeatId"
              items={race.qualificationRoundHeats}
              labelKey="number"
              onChange={onChange('qualificationRoundHeatId')}
              promptLabel=""
              promptValue=""
              value={data.qualificationRoundHeatId || ''}
            />
          </FormField>
          <FormField id="qualificationRoundTrackPlace" size="sm">
            <input
              id="qualificationRoundTrackPlace"
              type="number"
              min={1}
              value={data.qualificationRoundTrackPlace || ''}
              onChange={onChange('qualificationRoundTrackPlace')}
            />
          </FormField>
        </>
      )}
      {race.sport.shooting && race.finalRoundHeats.length > 0 && (
        <>
          <FormField id="finalRoundHeatId" labelId="finalRoundHeat" size="sm">
            <Select
              id="finalRoundHeatId"
              items={race.finalRoundHeats}
              labelKey="number"
              onChange={onChange('finalRoundHeatId')}
              promptLabel=""
              promptValue=""
              value={data.finalRoundHeatId || ''}
            />
          </FormField>
          <FormField id="finalRoundTrackPlace" size="sm">
            <input
              id="finalRoundTrackPlace"
              type="number"
              min={1}
              value={data.finalRoundTrackPlace || ''}
              onChange={onChange('finalRoundTrackPlace')}
            />
          </FormField>
        </>
      )}
      <div className="form__buttons">
        <Button submit={true} type="primary" disabled={saving}>{t('save')}</Button>
        {(isToday(new Date(race.startDate)) || isAfter(new Date(), new Date(race.startDate))) && (
          <>
            <Button onClick={submit('toEdit')} type="primary" disabled={saving}>{t('saveAndShowCompetitor')}</Button>
            {!race.sport.nordic && !race.sport.european && (
              <Button onClick={submit('toQuickSave')} type="primary" disabled={saving}>
                {t('saveAndToQuickSave')}
              </Button>
            )}
          </>
        )}
      </div>
    </form>
  )
}

export default CompetitorForm
