import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import isAfter from 'date-fns/isAfter'
import isToday from 'date-fns/isToday'
import FormField from '../../common/form/FormField'
import useCompetitorSaving from './useCompetitorSaving'
import { resolveClubTitle } from '../../util/clubUtil'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'
import FormErrors from '../../common/form/FormErrors'
import Dialog from '../../common/form/Dialog'
import Select from '../../common/form/Select'
import { buildOfficialCompetitorEditPath, buildOfficialRaceQuickSavesPath } from '../../util/routeUtil'
import { findSeriesById } from '../../util/seriesUtil'
import ThreeSportResultFields from './ThreeSportResultFields'
import ShootingRaceShotFields from './ShootingRaceShotFields'
import NordicShotFields from './NordicShotFields'
import EuropeanShotFields from './EuropeanShotFields'

const teamNameHelpDialogId = 'team_name_help_dialog'

const renderTeamNameHelpDialog = () => (
  <Dialog id={teamNameHelpDialogId} title="Joukkueen nimi">
    Jos kilpailija osallistuu joukkuekilpailuun, jossa joukkueita ei muodosteta seuran nimen perusteella, syötä tähän
    kenttään kilpailijan joukkueen nimi. Muussa tapauksessa jätä kenttä tyhjäksi.
  </Dialog>
)

const commonFields = [
  { key: 'seriesId', number: true },
  { key: 'ageGroupId', number: true },
  { key: 'firstName' },
  { key: 'lastName' },
  { key: 'unofficial', checkbox: true },
  { key: 'clubId', number: true },
  { key: 'teamName' },
  { key: 'number', number: true },
]

const newUserFields = [
  ...commonFields,
  { key: 'startTime' },
  { key: 'onlyRifle', checkbox: true },
  { key: 'qualificationRoundHeatId', number: true },
  { key: 'qualificationRoundTrackPlace', number: true },
  { key: 'finalRoundHeatId', number: true },
  { key: 'finalRoundTrackPlace', number: true },
]

const commonEditFields = [...commonFields, { key: 'shootingRulesPenalty', number: true }, { key: 'noResultReason' }]

const threeSportEditFields = [
  ...commonEditFields,
  { key: 'startTime' },
  { key: 'arrivalTime' },
  { key: 'estimate1', number: true },
  { key: 'estimate2', number: true },
  { key: 'estimate3', number: true },
  { key: 'estimate4', number: true },
  { key: 'shootingScoreInput', number: true },
  { key: 'shots', shotCount: 10 },
]

const shootingRaceEditFields = [
  ...commonEditFields,
  { key: 'qualificationRoundHeatId', number: true },
  { key: 'qualificationRoundShootingScoreInput', number: true },
  { key: 'qualificationRoundTrackPlace', number: true },
  { key: 'finalRoundHeatId', number: true },
  { key: 'finalRoundShootingScoreInput', number: true },
  { key: 'finalRoundTrackPlace', number: true },
  { key: 'extraShots', shotCount: 0 },
  { key: 'shootingRulesPenaltyQr', number: true },
]

const nordicEditFields = [
  ...commonEditFields,
  { key: 'nordicTrapScoreInput', number: true },
  { key: 'nordicTrapShots', shotCount: 25 },
  { key: 'nordicTrapExtraShots', shotCount: 0 },
  { key: 'nordicShotgunScoreInput', number: true },
  { key: 'nordicShotgunShots', shotCount: 25 },
  { key: 'nordicShotgunExtraShots', shotCount: 0 },
  { key: 'nordicRifleMovingScoreInput', number: true },
  { key: 'nordicRifleMovingShots', shotCount: 10 },
  { key: 'nordicRifleMovingExtraShots', shotCount: 0 },
  { key: 'nordicRifleStandingScoreInput', number: true },
  { key: 'nordicRifleStandingShots', shotCount: 10 },
  { key: 'nordicRifleStandingExtraShots', shotCount: 0 },
]

const nordicShotFields = [
  'nordicTrapShots',
  'nordicTrapExtraShots',
  'nordicShotgunShots',
  'nordicShotgunExtraShots',
  'nordicRifleMovingShots',
  'nordicRifleMovingExtraShots',
  'nordicRifleStandingShots',
  'nordicRifleStandingExtraShots',
]

const europeanEditFields = [
  ...commonEditFields,
  { key: 'onlyRifle', checkbox: true },
  { key: 'europeanTrapScoreInput', number: true },
  { key: 'europeanTrapScoreInput2', number: true },
  { key: 'europeanTrapShots', shotCount: 25 },
  { key: 'europeanTrapShots2', shotCount: 25 },
  { key: 'europeanCompakScoreInput', number: true },
  { key: 'europeanCompakScoreInput2', number: true },
  { key: 'europeanCompakShots', shotCount: 25 },
  { key: 'europeanCompakShots2', shotCount: 25 },
  { key: 'europeanRifle1ScoreInput', number: true },
  { key: 'europeanRifle1ScoreInput2', number: true },
  { key: 'europeanRifle1Shots', shotCount: 5 },
  { key: 'europeanRifle1Shots2', shotCount: 5 },
  { key: 'europeanRifle2ScoreInput', number: true },
  { key: 'europeanRifle2ScoreInput2', number: true },
  { key: 'europeanRifle2Shots', shotCount: 5 },
  { key: 'europeanRifle2Shots2', shotCount: 5 },
  { key: 'europeanRifle3ScoreInput', number: true },
  { key: 'europeanRifle3ScoreInput2', number: true },
  { key: 'europeanRifle3Shots', shotCount: 5 },
  { key: 'europeanRifle3Shots2', shotCount: 5 },
  { key: 'europeanRifle4ScoreInput', number: true },
  { key: 'europeanRifle4ScoreInput2', number: true },
  { key: 'europeanRifle4Shots', shotCount: 5 },
  { key: 'europeanRifle4Shots2', shotCount: 5 },
  { key: 'europeanRifleExtraShots', shotCount: 0 },
  { key: 'europeanShotgunExtraScore', number: true },
  { key: 'europeanExtraScore', number: true },
]

const europeanShotFields = [
  'europeanTrapShots',
  'europeanTrapShots2',
  'europeanCompakShots',
  'europeanCompakShots2',
  'europeanRifleExtraShots',
]
  .concat([1, 2, 3, 4].map((n) => [`europeanRifle${n}Shots`, `europeanRifle${n}Shots2`]))
  .flat()

const shotFieldsToBody = (shotFields, data, clubName) => {
  const body = shotFields.reduce(
    (acc, field) => {
      acc.competitor[field] = undefined
      acc[field] = data[field]
      return acc
    },
    { clubName, competitor: { ...data } },
  )
  if (!body.competitor.clubId) {
    body.competitor.clubId = undefined
  }
  return body
}

const resolveFields = (sport, editing) => {
  if (!editing) return newUserFields
  if (sport.nordic) return nordicEditFields
  if (sport.european) return europeanEditFields
  if (sport.shooting) {
    const shotCount = sport.qualificationRoundShotCount + sport.finalRoundShotCount
    return [...shootingRaceEditFields, { key: 'shots', shotCount }]
  }
  return threeSportEditFields
}

const competitorsOnlyToAgeGroups = (series) => series.name.match(/^S\d\d?$/)

const isTodayOrAfter = (startDate) => isToday(new Date(startDate)) || isAfter(new Date(), new Date(startDate))

const NoResultReasonOption = ({ data, onChange, option }) => {
  const { t } = useTranslation()
  const { noResultReason } = data
  return (
    <>
      <input type="radio" value={option} checked={noResultReason === option} onChange={onChange('noResultReason')} />{' '}
      {t(`noResultReason_${option}`)}
    </>
  )
}

const CompetitorForm = ({ race, availableSeries, competitor: initialCompetitor, onSeriesChange, onSave }) => {
  const { t } = useTranslation()
  const [clubName, setClubName] = useState('')
  const actionAfterSaveRef = useRef()
  const editing = !!initialCompetitor.id
  const fieldsRef = useRef(resolveFields(race.sport, editing))
  const formRef = useRef()

  const buildBody = useCallback(
    (_, data) => {
      if (race.sport.nordic) {
        return shotFieldsToBody(nordicShotFields, data, clubName)
      } else if (race.sport.european) {
        return shotFieldsToBody(europeanShotFields, data, clubName)
      } else if (race.sport.shooting) {
        return shotFieldsToBody(['shots', 'extraShots'], data, clubName)
      }
      const series = findSeriesById(availableSeries, data.seriesId)
      const body = shotFieldsToBody(['shots', 'extraShots'], data, clubName)
      if (!series.hasStartList) {
        body.competitor.number = undefined
        body.competitor.startTime = undefined
      }
      if (!body.competitor.clubId) {
        body.competitor.clubId = undefined
      }
      return body
    },
    [race, availableSeries, clubName],
  )

  const handleSave = useCallback(
    (competitor) => {
      if (actionAfterSaveRef.current === 'toEdit') {
        window.location.href = buildOfficialCompetitorEditPath(race.id, competitor.seriesId, competitor.id)
      } else if (actionAfterSaveRef.current === 'toQuickSave') {
        window.location.href = buildOfficialRaceQuickSavesPath(race.id)
      } else {
        setClubName('')
        onSave(competitor)
      }
    },
    [race, onSave],
  )

  const { changeValue, data, errors, onChange, onChangeShot, onSubmit, saving } = useCompetitorSaving(
    race.id,
    initialCompetitor,
    fieldsRef.current,
    buildBody,
    handleSave,
  )

  const handleSeriesChange = useCallback(
    (event) => {
      onChange('seriesId')(event)
      changeValue('ageGroupId', '')
      onSeriesChange(parseInt(event.target.value))
    },
    [onChange, onSeriesChange, changeValue],
  )

  const series = useMemo(() => findSeriesById(availableSeries, data.seriesId), [availableSeries, data.seriesId])

  const submit = useCallback(
    (action) => (event) => {
      actionAfterSaveRef.current = action
      onSubmit(event)
    },
    [onSubmit],
  )

  useEffect(() => {
    if (errors && errors.length > 0) formRef.current.scrollIntoView({ behavior: 'smooth' })
  }, [errors])

  const renderResultFields = () => {
    if (!editing) return
    if (race.sport.nordic) {
      return <NordicShotFields data={data} onChange={onChange} onChangeShot={onChangeShot} race={race} />
    } else if (race.sport.european) {
      return (
        <EuropeanShotFields
          data={data}
          onChange={onChange}
          onChangeShot={onChangeShot}
          doubleCompetition={race.doubleCompetition}
        />
      )
    } else if (race.sport.shooting) {
      return (
        <ShootingRaceShotFields
          competitorId={initialCompetitor.id}
          data={data}
          onChange={onChange}
          onChangeShot={onChangeShot}
          sport={race.sport}
        />
      )
    } else if (series.hasStartList) {
      return (
        <ThreeSportResultFields
          competitorId={initialCompetitor.id}
          data={data}
          onChange={onChange}
          onChangeShot={onChangeShot}
          fourEstimates={series.estimates === 4}
        />
      )
    }
  }

  const ageGroupLabel = t(race.sport.shooting ? 'ageGroupShooting' : 'ageGroup')
  const clubLabel = resolveClubTitle(t, race.clubLevel)
  const clubPromptLabel = t(editing ? 'addNewClub' : 'selectClubOrAddNew', { clubLabel: clubLabel.toLowerCase() })
  return (
    <form className="form" onSubmit={onSubmit} ref={formRef}>
      <FormErrors errors={errors} />
      <FormField id="seriesId" labelId="series" size="md">
        <Select id="seriesId" items={availableSeries} onChange={handleSeriesChange} value={data.seriesId} />
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
              promptLabel={clubPromptLabel}
              promptValue=""
              value={data.clubId || ''}
            />
          )}
          {!data.clubId && (
            <input
              id="club_name"
              value={clubName}
              onChange={(e) => setClubName(e.target.value)}
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
          <input id="number" type="number" min={0} value={data.number ?? ''} onChange={onChange('number')} />
        </FormField>
      )}
      {!race.sport.shooting && series.hasStartList && (
        <FormField id="startTime" size="md">
          <input id="startTime" value={data.startTime || ''} onChange={onChange('startTime')} placeholder="HH:MM:SS" />
        </FormField>
      )}
      {race.sport.shooting && !race.sport.nordic && !race.sport.european && race.qualificationRoundHeats.length > 0 && (
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
      {race.sport.shooting && !race.sport.nordic && !race.sport.european && race.finalRoundHeats.length > 0 && (
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
      {renderResultFields()}
      {editing && race.sport.qualificationRound && (
        <FormField id="shootingRulesPenaltyQr" size="sm">
          <input
            id="shootingRulesPenaltyQr"
            type="number"
            min={0}
            value={data.shootingRulesPenaltyQr || ''}
            onChange={onChange('shootingRulesPenaltyQr')}
          />
        </FormField>
      )}
      {editing && (series.hasStartList || race.sport.shooting) && (
        <FormField
          id="shootingRulesPenalty"
          labelId={race.sport.qualificationRound ? 'shootingRulesPenaltyFinal' : 'shootingRulesPenalty'}
          size="sm"
        >
          <input
            id="shootingRulesPenalty"
            type="number"
            min={0}
            value={data.shootingRulesPenalty || ''}
            onChange={onChange('shootingRulesPenalty')}
          />
        </FormField>
      )}
      {editing && (
        <FormField id="noResultReason">
          <NoResultReasonOption data={data} onChange={onChange} option="" />
          <NoResultReasonOption data={data} onChange={onChange} option="DNS" />
          <NoResultReasonOption data={data} onChange={onChange} option="DNF" />
          <NoResultReasonOption data={data} onChange={onChange} option="DQ" />
        </FormField>
      )}
      <div className="form__buttons">
        <Button submit={true} type="primary" disabled={saving}>
          {t('save')}
        </Button>
        {!editing && isTodayOrAfter(race.startDate) && (
          <>
            <Button onClick={submit('toEdit')} type="primary" disabled={saving}>
              {t('saveAndShowCompetitor')}
            </Button>
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
