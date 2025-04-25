import useTranslation from "../../util/useTranslation"
import useCompetitorResultSaving from "./useCompetitorResultSaving"
import { Fragment, useCallback, useMemo } from "react"
import { calculateShootingScore } from "./resultUtil"
import ResultRow from "./ResultRow"
import ShotFields from "./ShotFeilds"
import Button from "../../common/Button"

const EuropeanShotsForm = ({ competitor: initialCompetitor, subSport, config, withTrackPlace }) => {
  const { t } = useTranslation()
  const { fieldNames, shotCount, bestShotValue } = config

  const fields = useMemo(() => {
    const fieldConfig = [{ key: 'subSport', value: subSport }]
    fieldNames.forEach(field => {
      fieldConfig.push({ key: field.scoreInput, number: true })
      fieldConfig.push({ key: field.shots, shotCount })
    })
    return fieldConfig
  }, [subSport, fieldNames, shotCount])

  const buildBody = useCallback((_, data) => {
    const body = { competitor: {} }
    fieldNames.forEach(field => {
      body.competitor[field.scoreInput] = data[field.scoreInput]
      body[field.shots] = data[field.shots]
    })
    return body
  }, [fieldNames])

  const {
    changed,
    competitor,
    data,
    errors,
    onChange,
    onChangeShot,
    onSubmit,
    saved,
    saving,
  } = useCompetitorResultSaving(initialCompetitor, fields, buildBody)

  const dataHasCorrectFields = subSport === data.subSport

  const shootingScore = useMemo(() => {
    if (!dataHasCorrectFields) return ''
    return fieldNames.reduce((acc, field) => {
      if (typeof acc === 'string') return acc
      const score = calculateShootingScore(data[field.scoreInput], data[field.shots])
      if (typeof score === 'string') return score
      return acc + score
    }, 0)
  }, [dataHasCorrectFields, data, fieldNames])

  const allTens = useCallback(() => {
    fieldNames.forEach(field => {
      new Array(shotCount).fill(0).forEach((_, i) => {
        onChangeShot(field.shots, i)({ target: { value: bestShotValue } })
      })
    })
  }, [fieldNames, shotCount, onChangeShot, bestShotValue])

  if (!dataHasCorrectFields) return ''

  const renderSubTitle = fieldsIndex => {
    if (subSport !== 'rifle') return
    if (config.doubleCompetition) return fieldsIndex % 2 === 0 && <div>{t(`european_rifle${fieldsIndex / 2 + 1}`)}</div>
    return <div>{t(`european_rifle${fieldsIndex + 1}`)}</div>
  }

  return (
    <ResultRow
      competitor={competitor}
      errors={errors}
      result={shootingScore}
      saved={saved}
      saving={saving}
      withTrackPlace={withTrackPlace}
    >
      <form className="form form--inline" onSubmit={onSubmit}>
        {fieldNames.map((field, i) => (
          <Fragment key={i}>
            {renderSubTitle(i)}
            <div className="form__horizontal-fields">
              <ShotFields
                data={data}
                scoreInputField={field.scoreInput}
                maxScoreInput={shotCount * bestShotValue}
                shotsField={field.shots}
                onChange={onChange}
                onChangeShot={onChangeShot}
                shotCounts={[shotCount]}
                bestShotValue={bestShotValue}
              />
            </div>
          </Fragment>
        ))}
        <div className="form__buttons">
          <Button submit={true} type="primary" disabled={!changed}>{t('save')}</Button>
          {subSport === 'rifle' && <Button onClick={allTens}>{t('allTens')}</Button>}
        </div>
      </form>
    </ResultRow>
  )
}

export default EuropeanShotsForm
