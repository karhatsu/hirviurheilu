import useTranslation from "../../util/useTranslation"
import useCompetitorResultSaving from "./useCompetitorResultSaving"
import { useCallback, useMemo } from "react"
import { calculateShootingScore } from "./resultUtil"
import ResultRow from "./ResultRow"
import ShotFields from "./ShotFeilds"
import Button from "../../common/Button"

const EuropeanShotsForm = ({ competitor: initialCompetitor, subSport, config, withTrackPlace }) => {
  const { t } = useTranslation()
  const { fieldNames, shotCount, bestShotValue } = config

  const fields = useMemo(() => {
    return [
      { key: 'subSport', value: subSport },
      { key: fieldNames.scoreInput, number: true },
      { key: fieldNames.shots, shotCount },
    ]
  }, [subSport, fieldNames, shotCount])

  const buildBody = useCallback((_, data) => {
    const { scoreInput, shots } = fieldNames
    return {
      competitor: { [scoreInput]: data[scoreInput] },
      [shots]: data[shots],
    }
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
    return dataHasCorrectFields ? calculateShootingScore(data[fieldNames.scoreInput], data[fieldNames.shots]) : ''
  }, [dataHasCorrectFields, data, fieldNames])

  if (!dataHasCorrectFields) return ''

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
        <div className="form__horizontal-fields">
          <ShotFields
            data={data}
            scoreInputField={fieldNames.scoreInput}
            maxScoreInput={shotCount * bestShotValue}
            shotsField={fieldNames.shots}
            onChange={onChange}
            onChangeShot={onChangeShot}
            shotCounts={[shotCount]}
            bestShotValue={bestShotValue}
          />
        </div>
        <div className="form__buttons">
          <Button submit={true} type="primary" disabled={!changed}>{t('save')}</Button>
        </div>
      </form>
    </ResultRow>
  )
}

export default EuropeanShotsForm
