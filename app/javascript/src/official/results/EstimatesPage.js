import { useEffect } from "react"
import Button from "../../common/Button"
import IncompletePage from "../../common/IncompletePage"
import useTranslation from "../../util/useTranslation"
import useOfficialMenu from "../menu/useOfficialMenu"
import { useRace } from "../../util/useRace"
import useOfficialSeries from "./useOfficialSeries"
import ResultPage from "./ResultPage"
import useCompetitorResultSaving from "./useCompetitorResultSaving"
import ResultRow from "./ResultRow"
import { useParams } from "react-router"
import useTitle from "../../util/useTitle"

const EstimateField = ({ number, value, onChange }) => {
  return (
    <>
      <div className="form__field-prefix">#{number}</div>
      <div className="form__field form__field--sm">
        <input
          type="number"
          maxLength={3}
          min={1}
          value={value}
          onChange={onChange(`estimate${number}`)}
          name={`competitor[estimate${number}]`}
        />
      </div>
    </>
  )
}

const fields = ['estimate1', 'estimate2', 'estimate3', 'estimate4'].map(key => ({ key, number: true }))

const buildBody = (competitor, data) => ({
  noTimes: true,
  oldValues: {
    estimate1: competitor.estimate1,
    estimate2: competitor.estimate2,
    estimate3: competitor.estimate3,
    estimate4: competitor.estimate4,
  },
  ...data,
})

const EstimatesForm = ({ competitor: initialCompetitor, fourEstimates }) => {
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
  } = useCompetitorResultSaving(initialCompetitor, fields, buildBody)
  const { estimate1, estimate2, estimate3, estimate4 } = data

  const { estimatePoints } = competitor
  return (
    <ResultRow competitor={competitor} errors={errors} saved={saved} saving={saving} result={estimatePoints}>
      <form className="form form--inline" onSubmit={onSubmit}>
        <div className="form__horizontal-fields">
          <EstimateField number={1} value={estimate1} onChange={onChange}/>
          <EstimateField number={2} value={estimate2} onChange={onChange}/>
          {fourEstimates && <EstimateField number={3} value={estimate3} onChange={onChange}/>}
          {fourEstimates && <EstimateField number={4} value={estimate4} onChange={onChange}/>}
          <div className="form__buttons">
            <Button submit={true} type="primary" disabled={!changed}>{t('save')}</Button>
          </div>
        </div>
      </form>
    </ResultRow>
  )
}

const titleKey = 'officialRaceMenuEstimates'

const EstimatesPage = () => {
  const { t } = useTranslation()
  const { setSelectedPage } = useOfficialMenu()
  const { seriesId } = useParams()
  const { race } = useRace()
  const { error, fetching, series } = useOfficialSeries()

  useEffect(() => setSelectedPage('estimates'), [setSelectedPage])
  useTitle(race && series && `${t(titleKey)} - ${series.name} - ${race.name}`)

  const correctSeries = parseInt(seriesId) === series?.id
  if (!race || !series || !correctSeries) {
    return <IncompletePage title={t(titleKey)} error={error} fetching={fetching || !correctSeries} />
  }

  const fourEstimates = series?.estimates === 4
  const competitorClass = `col-xs-12 ${fourEstimates ? 'col-sm-12' : 'col-sm-6'}`
  return (
    <ResultPage competitorClass={competitorClass} race={race} series={series} titleKey={titleKey}>
      {competitor => <EstimatesForm competitor={competitor} fourEstimates={fourEstimates} />}
    </ResultPage>
  )
}

export default EstimatesPage
