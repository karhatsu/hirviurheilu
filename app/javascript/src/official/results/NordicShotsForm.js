import useTranslation from "../../util/useTranslation"
import useCompetitorResultSaving from "./useCompetitorResultSaving"
import { useCallback, useMemo } from "react"
import { calculateShootingScore, shotCount as countShots } from "./resultUtil"
import ResultRow from "./ResultRow"
import ShotFields from "./ShotFeilds"
import Button from "../../common/Button"

const NordicShotsForm = ({ competitor: initialCompetitor, subSport, config, series, withTrackPlace }) => {
  const { t } = useTranslation()
  const { fieldNames, shotCount, shotsPerExtraRound, bestShotValue } = config

  const fields = useMemo(() => {
    return [
      { key: 'subSport', value: subSport },
      { key: fieldNames.scoreInput, number: true },
      { key: fieldNames.shots, shotCount },
      { key: fieldNames.extraShots, shotCount: 0 },
    ]
  }, [subSport, fieldNames, shotCount])

  const buildBody = useCallback((_, data) => {
    const { scoreInput, shots, extraShots } = fieldNames
    return {
      competitor: { [scoreInput]: data[scoreInput] },
      [shots]: data[shots],
      [extraShots]: data[extraShots],
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

  const extraRoundShotCount = useMemo(() => {
    if (!dataHasCorrectFields) return 0
    const { scoreInput, shots, extraShots } = fieldNames
    if (data[scoreInput] || countShots(data[shots]) === shotCount) {
      const currentCount = (data[extraShots] || []).length
      return currentCount + shotsPerExtraRound - currentCount % shotsPerExtraRound
    }
    return 0
  }, [dataHasCorrectFields, data, fieldNames, shotCount, shotsPerExtraRound])

  const shootingScore = useMemo(() => {
    if (!dataHasCorrectFields) return ''
    const maxScore = shotCount * bestShotValue
    return calculateShootingScore(data[fieldNames.scoreInput], data[fieldNames.shots], maxScore)
  }, [dataHasCorrectFields, data, fieldNames, shotCount, bestShotValue])

  if (!dataHasCorrectFields) return ''

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
        {extraRoundShotCount > 0 && (
          <>
            <div>{t('extraRound')}</div>
            <ShotFields
              data={data}
              shotsField={fieldNames.extraShots}
              onChangeShot={onChangeShot}
              shotCounts={[extraRoundShotCount]}
              bestShotValue={bestShotValue}
            />
          </>
        )}
        <div className="form__buttons">
          <Button submit={true} type="primary" disabled={!changed}>{t('save')}</Button>
        </div>
      </form>
    </ResultRow>
  )
}

export default NordicShotsForm
