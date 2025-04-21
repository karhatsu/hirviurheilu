import { useMemo } from "react"
import Button from "../../common/Button"
import useTranslation from "../../util/useTranslation"
import useCompetitorResultSaving from "./useCompetitorResultSaving"
import ResultRow from "./ResultRow"
import { calculateShootingScore } from "./resultUtil"
import ShotFields from "./ShotFeilds"

const fields = [
  { key: 'shootingScoreInput', number: true },
  { key: 'shots', shotCount: 10 },
]

const buildBody = (_, data) => {
  return { competitor: { shootingScoreInput: data.shootingScoreInput }, shots: data.shots }
}

const ThreeSportsShootingForm = ({ competitor: initialCompetitor, sport }) => {
  const { t } = useTranslation()
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

  const shootingScore = useMemo(() => {
    return calculateShootingScore(data.shootingScoreInput, data.shots)
  }, [data])

  return (
    <ResultRow competitor={competitor} errors={errors} result={shootingScore} saved={saved} saving={saving}>
      <form className="form form--inline" onSubmit={onSubmit}>
        <div className="form__horizontal-fields">
          <ShotFields
            data={data}
            scoreInputField="shootingScoreInput"
            maxScoreInput={100}
            shotsField="shots"
            onChange={onChange}
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
