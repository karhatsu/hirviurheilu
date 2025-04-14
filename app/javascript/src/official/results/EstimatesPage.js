import { useCallback, useEffect } from "react"
import Button from "../../common/Button"
import IncompletePage from "../../common/IncompletePage"
import useTranslation from "../../util/useTranslation"
import useOfficialMenu from "../menu/useOfficialMenu"
import Message from "../../common/Message"
import Spinner from "../../common/Spinner"
import { useRace } from "../../util/useRace"
import useOfficialSeries from "./useOfficialSeries"
import ResultPage from "./ResultPage"
import useCompetitorResultSaving from "./useCompetitorResultSaving"

const EstimateField = ({ number, value, onChange }) => {
  const handleChange = useCallback(e => onChange(`estimate${number}`, parseInt(e.target.value)), [number, onChange])
  return (
    <>
      <div className="form__field-prefix">#{number}</div>
      <div className="form__field form__field--sm">
        <input
          type="number"
          maxLength={3}
          min={1}
          value={value}
          onChange={handleChange}
          name={`competitor[estimate${number}]`}
        />
      </div>
    </>
  )
}

const fields = ['estimate1', 'estimate2', 'estimate3', 'estimate4']

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

const CompetitorForm = ({ competitor: initialCompetitor, fourEstimates }) => {
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

  const { estimatePoints, firstName, lastName, noResultReason, number } = competitor
  return (
    <div className="card">
      <div className="card__number">{number}</div>
      <div className="card__middle">
        <div className="card__name">
          <span>{lastName} {firstName}</span>
          {saving && <Spinner />}
          {errors && <Message inline={true} type="error">{errors.join('. ')}.</Message>}
          {saved && <Message inline={true} type="success">{t('saved')}</Message>}
        </div>
        {!noResultReason && (
          <div className="card__middle-row">
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
          </div>
        )}
      </div>
      <div className="card__main-value">
        {noResultReason && <div>{noResultReason}</div>}
        {!noResultReason && <div>{estimatePoints}</div>}
      </div>
    </div>
  )
}

const titleKey = 'officialRaceMenuEstimates'

const EstimatesPage = () => {
  const { t } = useTranslation()
  const { setSelectedPage } = useOfficialMenu()
  const { race } = useRace()
  const { error, fetching, series } = useOfficialSeries()

  useEffect(() => setSelectedPage('estimates'), [setSelectedPage])

  if (!race || !series) return <IncompletePage title={t(titleKey)} error={error} fetching={fetching} />

  const fourEstimates = series?.estimates === 4
  const competitorClass = `col-xs-12 ${fourEstimates ? 'col-sm-12' : 'col-sm-6'}`
  return (
    <ResultPage competitorClass={competitorClass} race={race} series={series} titleKey={titleKey}>
      {competitor => <CompetitorForm competitor={competitor} fourEstimates={fourEstimates} />}
    </ResultPage>
  )
}

export default EstimatesPage
