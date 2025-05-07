import useTranslation from '../../util/useTranslation'
import useCompetitorSaving from '../competitors/useCompetitorSaving'
import { Fragment, useCallback, useMemo } from 'react'
import { calculateShootingScore } from './resultUtil'
import ResultRow from './ResultRow'
import ShotFields from './ShotFields'
import Button from '../../common/Button'
import { useParams } from 'react-router'
import ScoreInputField from './ScoreInputField'

const EuropeanShotsForm = ({ competitor: initialCompetitor, series, subSport, config, withTrackPlace }) => {
  const { t } = useTranslation()
  const { fieldNames, shotCount, bestShotValue } = config
  const { raceId } = useParams()

  const fields = useMemo(() => {
    const fieldConfig = [{ key: 'subSport', value: subSport }]
    fieldNames.forEach((field) => {
      fieldConfig.push({ key: field.scoreInput, number: true })
      fieldConfig.push({ key: field.shots, shotCount })
    })
    return fieldConfig
  }, [subSport, fieldNames, shotCount])

  const buildBody = useCallback(
    (_, data) => {
      const body = { competitor: {} }
      fieldNames.forEach((field) => {
        body.competitor[field.scoreInput] = data[field.scoreInput]
        body[field.shots] = data[field.shots]
      })
      return body
    },
    [fieldNames],
  )

  const { changed, competitor, data, errors, onChange, onChangeShot, onSubmit, saved, saving } = useCompetitorSaving(
    raceId,
    initialCompetitor,
    fields,
    buildBody,
  )

  const dataHasCorrectFields = subSport === data.subSport

  const shootingScore = useMemo(() => {
    if (!dataHasCorrectFields) return ''
    const maxScore = shotCount * bestShotValue
    const scores = fieldNames.map((field) =>
      calculateShootingScore(data[field.scoreInput], data[field.shots], maxScore),
    )
    if (scores.find((score) => score === '?')) return '?'
    if (!scores.filter((score) => score !== '').length) return ''
    return scores.reduce((acc, score) => acc + (score || 0), 0)
  }, [dataHasCorrectFields, data, fieldNames, shotCount, bestShotValue])

  const allTens = useCallback(() => {
    fieldNames.forEach((field) => {
      new Array(shotCount).fill(0).forEach((_, i) => {
        onChangeShot(field.shots, i)({ target: { value: bestShotValue } })
      })
    })
  }, [fieldNames, shotCount, onChangeShot, bestShotValue])

  if (!dataHasCorrectFields) return ''

  const renderSubTitle = (fieldsIndex) => {
    if (subSport !== 'rifle') return
    if (config.doubleCompetition) {
      return fieldsIndex % 2 === 0 && <div className="form__subtitle">{t(`european_rifle${fieldsIndex / 2 + 1}`)}</div>
    }
    return <div className="form__subtitle">{t(`european_rifle${fieldsIndex + 1}`)}</div>
  }

  return (
    <ResultRow
      competitor={competitor}
      errors={errors}
      result={shootingScore}
      saved={saved}
      saving={saving}
      seriesName={series.name}
      withTrackPlace={withTrackPlace}
    >
      <form className="form form--inline" onSubmit={onSubmit}>
        {fieldNames.map((field, i) => (
          <Fragment key={i}>
            {renderSubTitle(i)}
            <div className="form__horizontal-fields">
              <div className="card__sub-result card__sub-result--shoot form__field form__field--sm">
                <ScoreInputField
                  data={data}
                  field={field.scoreInput}
                  maxScoreInput={shotCount * bestShotValue}
                  onChange={onChange}
                />
              </div>
              <div className="card__sub-result card__sub-result--shoot">
                <ShotFields
                  idPrefix={`european_${subSport}${subSport === 'rifle' ? i + 1 : ''}_shots-shot-${competitor.id}`}
                  data={data}
                  shotsField={field.shots}
                  onChangeShot={onChangeShot}
                  shotCounts={[shotCount]}
                  bestShotValue={bestShotValue}
                />
              </div>
            </div>
          </Fragment>
        ))}
        <div className="form__buttons">
          <Button submit={true} type="primary" disabled={!changed}>
            {t('save')}
          </Button>
          {subSport === 'rifle' && <Button onClick={allTens}>{t('allTens')}</Button>}
        </div>
      </form>
    </ResultRow>
  )
}

export default EuropeanShotsForm
