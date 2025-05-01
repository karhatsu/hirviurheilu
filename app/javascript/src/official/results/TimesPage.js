import useOfficialMenu from "../menu/useOfficialMenu"
import { useRace } from "../../util/useRace"
import { useEffect } from "react"
import useTranslation from "../../util/useTranslation"
import useOfficialSeries from "./useOfficialSeries"
import IncompletePage from "../../common/IncompletePage"
import ResultPage from "./ResultPage"
import Button from "../../common/Button"
import { timeFromSeconds } from "../../util/timeUtil"
import useCompetitorSaving from "../competitors/useCompetitorSaving"
import ResultRow from "./ResultRow"
import { useParams } from "react-router"
import useTitle from "../../util/useTitle"

const titleKey = 'officialRaceMenuTimes'

const timeRegex = /^(?:[01]\d|2[0-3]):[0-5]\d:[0-5]\d$/

const isValid = time => time === '' || time.match(timeRegex)

const TimeField = ({ field, times, onChange, name }) => (
  <input value={times[field]} onChange={onChange(field)} placeholder="HH:MM:SS" name={name} />
)

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
  } = useCompetitorSaving(initialCompetitor, fields)

  const canSave = changed && isValid(data.startTime) && isValid(data.arrivalTime)
  const result = timeFromSeconds(competitor.timeInSeconds)
  return (
    <ResultRow competitor={competitor} errors={errors} saved={saved} saving={saving} result={result}>
      <form className="form form--inline" onSubmit={onSubmit}>
        <div className="form__horizontal-fields">
          <div className="form__field form__field--sm">
            <TimeField field="startTime" times={data} onChange={onChange} name="competitor[start_time]" />
          </div>
          <div className="card__sub-result card__sub-result--time form__field form__field--sm">
            <TimeField field="arrivalTime" times={data} onChange={onChange} name="competitor[arrival_time]" />
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
  const { seriesId } = useParams()
  const {race} = useRace()
  const {error, fetching, series} = useOfficialSeries()

  useEffect(() => setSelectedPage('times'), [setSelectedPage])
  useTitle(race && series && `${t(titleKey)} - ${series.name} - ${race.name}`)

  const correctSeries = parseInt(seriesId) === series?.id
  if (!race || !series || !correctSeries) {
    return <IncompletePage title={t(titleKey)} error={error} fetching={fetching || !correctSeries} />
  }

  return (
    <ResultPage race={race} series={series} titleKey={titleKey} competitorClass="col-sm-6">
      {competitor => <TimesForm competitor={competitor}/>}
    </ResultPage>
  )
}

export default TimesPage
