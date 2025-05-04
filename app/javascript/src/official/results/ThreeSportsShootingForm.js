import { useMemo } from "react"
import Button from "../../common/Button"
import useTranslation from "../../util/useTranslation"
import useCompetitorSaving from "../competitors/useCompetitorSaving"
import ResultRow from "./ResultRow"
import { calculateShootingScore } from "./resultUtil"
import ShotFields from "./ShotFields"
import { useParams } from "react-router"
import ScoreInputField from "./ScoreInputField"

const fields = [
  { key: 'shootingScoreInput', number: true },
  { key: 'shots', shotCount: 10 },
]

const buildBody = (_, data) => {
  return { competitor: { shootingScoreInput: data.shootingScoreInput }, shots: data.shots }
}

const ThreeSportsShootingForm = ({ competitor: initialCompetitor, sport }) => {
  const { t } = useTranslation()
  const { raceId } = useParams()
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
  } = useCompetitorSaving(raceId, initialCompetitor, fields, buildBody)

  const shootingScore = useMemo(() => {
    return calculateShootingScore(data.shootingScoreInput, data.shots, 100)
  }, [data])

  return (
    <ResultRow competitor={competitor} errors={errors} result={shootingScore} saved={saved} saving={saving}>
      <form className="form form--inline" onSubmit={onSubmit}>
        <div className="form__horizontal-fields">
          <div className="card__sub-result card__sub-result--shoot form__field form__field--sm">
            <ScoreInputField
              data={data}
              field="shootingScoreInput"
              maxScoreInput={100}
              onChange={onChange}
            />
          </div>
          <ShotFields
            data={data}
            shotsField="shots"
            onChangeShot={onChangeShot}
            shotCounts={[10]}
            bestShotValue={sport.bestShotValue}
          />
          <div className="form__buttons">
            <Button submit={true} type="primary" disabled={!changed}>{t('save')}</Button>
          </div>
        </div>
      </form>
    </ResultRow>
  )
}

export default ThreeSportsShootingForm
