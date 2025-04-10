import { useCallback, useEffect, useState } from "react"
import Button from "../../common/Button"
import {
  buildOfficialRacePath,
  buildOfficialSeriesEstimatesPath,
  buildOfficialSeriesShotsPath,
  buildOfficialSeriesTimesPath,
} from "../../util/routeUtil"
import IncompletePage from "../../common/IncompletePage"
import useTranslation from "../../util/useTranslation"
import { useParams } from "react-router"
import useOfficialMenu from "../menu/useOfficialMenu"
import { get, put } from "../../util/apiClient"
import Message from "../../common/Message"
import Spinner from "../../common/Spinner"
import { useRace } from "../../util/useRace"
import SeriesMobileSubMenu from "../../public/menu/SeriesMobileSubMenu"

const EstimateField = ({ number, value, onChange }) => {
  const handleChange = useCallback(e => onChange(number, parseInt(e.target.value)), [number, onChange])
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

const CompetitorForm = ({ seriesId, competitor: initialCompetitor, fourEstimates }) => {
  const { t } = useTranslation()
  const [competitor, setCompetitor] = useState(initialCompetitor)
  const [estimates, setEstimates] = useState(() => {
    const { estimate1, estimate2, estimate3, estimate4 } = competitor
    return { estimate1, estimate2, estimate3, estimate4 }
  })
  const [saving, setSaving] = useState(false)
  const [errors, setErrors] = useState()
  const [saved, setSaved] = useState(false)
  const { estimate1, estimate2, estimate3, estimate4 } = estimates

  const onChange = useCallback((n, value) => {
    setSaved(false)
    setErrors(undefined)
    setEstimates(prev => ({ ...prev, [`estimate${n}`]: value }))
  }, [])

  const onSubmit = useCallback(event => {
    event.preventDefault()
    setSaving(true)
    setErrors(undefined)
    setSaved(false)
    const body = {
      noTimes: true,
      oldValues: {
        estimate1: competitor.estimate1,
        estimate2: competitor.estimate2,
        estimate3: competitor.estimate3,
        estimate4: competitor.estimate4,
      },
      ...estimates,
    }
    const path = `/official/series/${seriesId}/competitors/${competitor.id}.json`
    put(path, body, (err, response) => {
      setSaving(false)
      if (err) {
        setErrors(err)
      } else {
        setCompetitor(response)
        setSaved(true)
      }
    })
  }, [seriesId, competitor, estimates])

  const { estimatePoints, firstName, lastName, noResultReason, number } = competitor
  const changed = estimate1 !== competitor.estimate1
    || estimate2 !== competitor.estimate2
    || estimate3 !== competitor.estimate3
    || estimate4 !== competitor.estimate4
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

const EstimatesPage = () => {
  const {raceId, seriesId} = useParams()
  const {t} = useTranslation()
  const [series, setSeries] = useState()
  const [error, setError] = useState()
  const [fetching, setFetching] = useState(true)
  const { setSelectedPage } = useOfficialMenu()
  const { race } = useRace()

  useEffect(() => setSelectedPage('estimates'), [setSelectedPage])

  useEffect(() => {
    setFetching(true)
    get(`/official/races/${raceId}/series/${seriesId}`, (err, response) => {
      if (err) setError(err)
      else setSeries(response)
      setFetching(false)
    })
  }, [raceId, seriesId])

  const fourEstimates = series?.estimates === 4

  if (!race || !series) return <IncompletePage title={t('estimates')} error={error} fetching={fetching} />

  const content = () => {
    if (!series.competitors.length) {
      return <Message type="info">{t('noCompetitorsInSeries')}</Message>
    } else if (race.sport.startList && !series.hasStartList) {
      return (
        <>
          <Message type="info">{t('noStartListForSeries')}</Message>
          <Button href={`/official/series/${seriesId}/competitors`}>{t('generateStartTimes')}</Button>
        </>
      )
    } else {
      const competitorClass = `col-xs-12 ${fourEstimates ? 'col-sm-12' : 'col-sm-6'}`
      return (
        <div className="row">
          {series.competitors.map(competitor => (
            <div key={competitor.id} className={competitorClass}>
              <CompetitorForm competitor={competitor} fourEstimates={fourEstimates} seriesId={seriesId}/>
            </div>
          ))}
        </div>
      )
    }
  }
  return (
    <div>
      <h2>{series.name} - {t('estimates')}</h2>
      {content()}
      {race.series.length > 1 && (
        <SeriesMobileSubMenu
          race={race}
          buildSeriesPath={buildOfficialSeriesEstimatesPath}
          currentSeriesId={seriesId}
        />
      )}
      <div className="buttons buttons--nav">
        <Button href={buildOfficialRacePath(raceId)} type="back">{t('backToOfficialRacePage')}</Button>
        <Button href={buildOfficialSeriesTimesPath(raceId, seriesId)}>{t('officialRaceMenuTimes')}</Button>
        <Button href={buildOfficialSeriesShotsPath(raceId, seriesId)}>{t('officialRaceMenuShooting')}</Button>
      </div>
    </div>
  )
}

export default EstimatesPage
