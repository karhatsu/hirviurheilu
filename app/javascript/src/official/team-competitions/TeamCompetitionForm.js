import useTranslation from '../../util/useTranslation'
import { useCallback, useState } from 'react'
import FormErrors from '../../common/form/FormErrors'
import Button from '../../common/Button'
import Dialog from '../../common/form/Dialog'
import FormField from '../../common/form/FormField'
import Message from '../../common/Message'
import ClubExtraShotsFormRow from './ClubExtraShotsFormRow'

const teamNameHelpDialogId = 'team_name_help_dialog'

const TeamCompetitionForm = ({ errors, initialData, onCancel, onSave, race, title }) => {
  const { t } = useTranslation()
  const [data, setData] = useState(initialData)

  const onChange = useCallback((field) => (event) => setData((d) => ({ ...d, [field]: event.target.value })), [])

  const onCheckboxChange = useCallback(
    (field) => (event) => setData((d) => ({ ...d, [field]: event.target.checked })),
    [],
  )

  const onSeriesCheckboxChange = useCallback(
    (seriesId) => () => {
      setData((prev) => {
        const seriesIds = prev.seriesIds.includes(seriesId)
          ? prev.seriesIds.filter((id) => id !== seriesId)
          : [...prev.seriesIds, seriesId]
        return { ...prev, seriesIds }
      })
    },
    [],
  )

  const onAgeGroupCheckboxChange = useCallback(
    (ageGroupId) => () => {
      setData((prev) => {
        const ageGroupIds = prev.ageGroupIds.includes(ageGroupId)
          ? prev.ageGroupIds.filter((id) => id !== ageGroupId)
          : [...prev.ageGroupIds, ageGroupId]
        return { ...prev, ageGroupIds }
      })
    },
    [],
  )

  const addExtraScoreNordic = useCallback(() => {
    setData((prev) => {
      const extraShots = [...(prev.extraShots || []), { clubId: '', score1: '', score2: '' }]
      return { ...prev, extraShots }
    })
  }, [])

  const addExtraShotsShotgun = useCallback(() => {
    setData((prev) => {
      const extraShots = [...(prev.extraShots || []), { clubId: '', shots1: '', shots2: '' }]
      return { ...prev, extraShots }
    })
  }, [])

  const onExtraShotsChange = useCallback(
    (index) => (field) => (event) => {
      setData((prev) => {
        const extraShots = [...prev.extraShots]
        extraShots[index] = { ...extraShots[index], [field]: event.target.value }
        return { ...prev, extraShots }
      })
    },
    [],
  )

  const onSubmit = useCallback(
    (event) => {
      event.preventDefault()
      onSave(data)
    },
    [onSave, data],
  )

  const renderNumber = (field, min) => (
    <FormField id={field} labelId={field} size="sm">
      <input id={field} type="number" value={data[field] || ''} onChange={onChange(field)} min={min} />
    </FormField>
  )

  const renderCheckbox = (field, helpDialogId) => (
    <FormField id={field} labelId={field} helpDialogId={helpDialogId}>
      <input id={field} type="checkbox" checked={data[field]} onChange={onCheckboxChange(field)} />
    </FormField>
  )

  const raceTypeKeySuffix = race.sport.shooting ? 'Shooting' : 'ThreeSports'
  return (
    <div>
      <h2>{title}</h2>
      <FormErrors errors={errors} />
      <form className="form" onSubmit={onSubmit}>
        <FormField id="name" labelId="teamCompetitionName">
          <input id="name" type="text" value={data.name} onChange={onChange('name')} />
        </FormField>
        {renderNumber('teamCompetitorCount', 2)}
        {renderCheckbox('multipleTeams')}
        {renderCheckbox('showPartialTeams')}
        {renderCheckbox('useTeamName', teamNameHelpDialogId)}
        {renderNumber('nationalRecord', 0)}
        <Dialog id={teamNameHelpDialogId} title="Joukkueen nimi">
          <p>
            Normaalisti joukkueet muodostetaan piirin tai seuran perusteella. Jos kuitenkin valitset kohdan
            {t('attributes.use_team_name')}, joukkueet muodostetaan jokaiselle kilpailijalle syötetyn joukkueen nimen
            perusteella. Tällöin yhden joukkueen jäsenten ei tarvitse kuulua samaan piiriin tai seuraan ja toisaalta
            samasta piirista tai seurasta voidaan muodostaa useita joukkueita.
          </p>
          <p>Voit asettaa kilpailijalle joukkueen nimen muokkaamalla kilpailijan perustietoja.</p>
        </Dialog>
        <h3>{t(`teamCompetitionSeries${raceTypeKeySuffix}`)}</h3>
        <Message type="info">{t(`teamCompetitionSeriesInfo${raceTypeKeySuffix}`)}</Message>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 16, marginTop: 16 }}>
          {race.series.map((series) => (
            <div key={series.id} style={{ display: 'flex', gap: '6px 8px', flexWrap: 'wrap' }}>
              <label style={{ display: 'flex', gap: 4, alignItems: 'center', flexWrap: 'nowrap' }}>
                <input
                  type="checkbox"
                  checked={data.seriesIds.includes(series.id)}
                  onChange={onSeriesCheckboxChange(series.id)}
                  disabled={series.ageGroups.find((ag) => data.ageGroupIds.includes(ag.id))}
                />
                {series.name}
              </label>
              {series.ageGroups.map((ageGroup) => (
                <label key={ageGroup.id} style={{ display: 'flex', gap: 4, alignItems: 'center', flexWrap: 'nowrap' }}>
                  <input
                    type="checkbox"
                    checked={data.ageGroupIds.includes(ageGroup.id)}
                    onChange={onAgeGroupCheckboxChange(ageGroup.id)}
                    disabled={data.seriesIds.includes(series.id)}
                  />
                  {ageGroup.name}
                </label>
              ))}
            </div>
          ))}
        </div>
        {!!data.id && race.sport.nordic && (
          <div>
            <h3>{t('extraShots')}</h3>
            <Message type="info">{t('teamCompetitionExtraShotsInfoNordic')}</Message>
            {(data.extraShots || []).map((clubExtraShots, i) => (
              <ClubExtraShotsFormRow
                key={i}
                race={race}
                clubExtraShots={clubExtraShots}
                onChange={onExtraShotsChange(i)}
                resultKey="score"
              />
            ))}
            <div className="form__buttons">
              <Button onClick={addExtraScoreNordic}>{t('add')}</Button>
            </div>
          </div>
        )}
        {!!data.id && race.sport.bestShotValue === 1 && (
          <div>
            <h3>{t('extraShots')}</h3>
            <Message type="info">{t('teamCompetitionExtraShotsInfoShotgun')}</Message>
            {(data.extraShots || []).map((clubExtraShots, i) => (
              <ClubExtraShotsFormRow
                key={i}
                race={race}
                clubExtraShots={clubExtraShots}
                onChange={onExtraShotsChange(i)}
                resultKey="shots"
              />
            ))}
            <div className="form__buttons">
              <Button onClick={addExtraShotsShotgun}>{t('add')}</Button>
            </div>
          </div>
        )}
        <div className="form__buttons">
          <Button submit={true} type="primary">
            {t('save')}
          </Button>
        </div>
      </form>
      <div className="buttons buttons--nav">
        <Button onClick={onCancel} type="back">
          {t('cancel')}
        </Button>
      </div>
    </div>
  )
}

export default TeamCompetitionForm
