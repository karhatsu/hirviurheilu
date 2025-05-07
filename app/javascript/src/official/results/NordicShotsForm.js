import useTranslation from '../../util/useTranslation'
import useCompetitorSaving from '../competitors/useCompetitorSaving'
import { useCallback, useMemo } from 'react'
import { calculateShootingScore, shotCount as countShots } from './resultUtil'
import ResultRow from './ResultRow'
import ShotFields from './ShotFields'
import Button from '../../common/Button'
import { useParams } from 'react-router'
import ScoreInputField from './ScoreInputField'

const NordicShotsForm = ({ competitor: initialCompetitor, subSport, config, series, withTrackPlace }) => {
  const { t } = useTranslation()
  const { fieldNames, shotCount, shotsPerExtraRound, bestShotValue, bestExtraShotValue } = config
  const { raceId } = useParams()

  const fields = useMemo(() => {
    return [
      { key: 'subSport', value: subSport },
      { key: fieldNames.scoreInput, number: true },
      { key: fieldNames.shots, shotCount },
      { key: fieldNames.extraShots, shotCount: 0 },
    ]
  }, [subSport, fieldNames, shotCount])

  const buildBody = useCallback(
    (_, data) => {
      const { scoreInput, shots, extraShots } = fieldNames
      return {
        competitor: { [scoreInput]: data[scoreInput] },
        [shots]: data[shots],
        [extraShots]: data[extraShots],
      }
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

  const extraRoundShotCount = useMemo(() => {
    if (!dataHasCorrectFields) return 0
    const { scoreInput, shots, extraShots } = fieldNames
    if (data[scoreInput] || countShots(data[shots]) === shotCount) {
      const currentCount = (data[extraShots] || []).length
      return currentCount + shotsPerExtraRound - (currentCount % shotsPerExtraRound)
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
          <div className="card__sub-result card__sub-result--shoot form__field form__field--sm">
            <ScoreInputField
              data={data}
              field={fieldNames.scoreInput}
              maxScoreInput={shotCount * bestShotValue}
              onChange={onChange}
            />
          </div>
          <div className="card__sub-result card__sub-result--shoot">
            <ShotFields
              idPrefix={`nordic_${subSport}_shots-shot-${competitor.id}`}
              data={data}
              shotsField={fieldNames.shots}
              onChangeShot={onChangeShot}
              shotCounts={[shotCount]}
              bestShotValue={bestShotValue}
            />
          </div>
        </div>
        {extraRoundShotCount > 0 && (
          <>
            <div className="form__subtitle">{t('extraRound')}</div>
            <div className="card__sub-result card__sub-result--shoot">
              <ShotFields
                idPrefix={`nordic_${subSport}_extra-shot-${competitor.id}`}
                data={data}
                shotsField={fieldNames.extraShots}
                onChangeShot={onChangeShot}
                shotCounts={[extraRoundShotCount]}
                bestShotValue={bestExtraShotValue}
              />
            </div>
          </>
        )}
        <div className="form__buttons">
          <Button submit={true} type="primary" disabled={!changed}>
            {t('save')}
          </Button>
        </div>
      </form>
    </ResultRow>
  )
}

export default NordicShotsForm
