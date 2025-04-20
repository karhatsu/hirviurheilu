import useOfficialMenu from "../menu/useOfficialMenu"
import { useRace } from "../../util/useRace"
import { useCallback, useEffect } from "react"
import useTranslation from "../../util/useTranslation"
import useOfficialSeries from "./useOfficialSeries"
import IncompletePage from "../../common/IncompletePage"
import ResultPage from "./ResultPage"
import Button from "../../common/Button"
import { timeFromSeconds } from "../../util/timeUtil"
import useCompetitorResultSaving from "./useCompetitorResultSaving"
import ResultRow from "./ResultRow"

const titleKey = 'officialRaceMenuTimes'

const timeRegex = /^(?:[01]\d|2[0-3]):[0-5]\d:[0-5]\d$/

const isValid = time => time === '' || time.match(timeRegex)

const TimeField = ({ field, times, onChange }) => {
  const handleChange = useCallback(() => onChange(field), [field, onChange])
  return <input value={times[field]} onChange={handleChange} placeholder="HH:MM:SS" />
}

const fields = ['startTime', 'arrivalTime'].map(key => ({ key }))

const TimesForm = ({competitor: initialCompetitor}) => {
  const { t } = useTranslation()
  const {
    changed,
    competitor,
    data,
    errors,
    onChange,
    onSubmit,
    saved,
    saving,
  } = useCompetitorResultSaving(initialCompetitor, fields)

  const canSave = changed && isValid(data.startTime) && isValid(data.arrivalTime)
  const result = timeFromSeconds(competitor.timeInSeconds)
  return (
    <ResultRow competitor={competitor} errors={errors} saved={saved} saving={saving} result={result}>
      <form className="form form--inline" onSubmit={onSubmit}>
        <div className="form__horizontal-fields">
          <div className="form__field form__field--sm">
            <TimeField field="startTime" times={data} onChange={onChange}/>
          </div>
          <div className="card__sub-result card__sub-result--time form__field form__field--sm">
            <TimeField field="arrivalTime" times={data} onChange={onChange}/>
          </div>
          <div className="form__buttons">
            <Button submit={true} type="primary" disabled={!canSave}>{t('save')}</Button>
          </div>
        </div>
      </form>
    </ResultRow>
  )
}

const TimesPage = () => {
  const {t} = useTranslation()
  const {setSelectedPage} = useOfficialMenu()
  const {race} = useRace()
  const {error, fetching, series} = useOfficialSeries()

  useEffect(() => setSelectedPage('times'), [setSelectedPage])

  if (!race || !series) return <IncompletePage title={t(titleKey)} error={error} fetching={fetching}/>

  return (
    <ResultPage race={race} series={series} titleKey={titleKey} competitorClass="col-sm-6">
      {competitor => <TimesForm competitor={competitor}/>}
    </ResultPage>
  )
}

export default TimesPage
