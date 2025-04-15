import { useMemo } from "react"
import Button from "../../common/Button"
import useTranslation from "../../util/useTranslation"
import useCompetitorResultSaving from "./useCompetitorResultSaving"
import ResultRow from "./ResultRow"

const fields = [
  { key: 'shootingScoreInput', number: true },
  { key: 'shots', shotCount: 10 },
]

const buildBody = (_, data) => {
  return { competitor: { shootingScoreInput: data.shootingScoreInput }, shots: data.shots }
}

const shotSum = shots => shots.reduce((sum, shot) => sum + (shot || 0), 0)

const ThreeSportsShootingForm = ({ competitor: initialCompetitor }) => {
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
    const totalInput = data.shootingScoreInput
    const hasShot = !!data.shots.find(s => s)
    if (totalInput) {
      if (totalInput < 0 || totalInput > 100  || hasShot) return '?'
      return totalInput
    } else if (hasShot) {
      return shotSum(data.shots)
    }
    return ''
  }, [data])

  return (
    <ResultRow competitor={competitor} errors={errors} result={shootingScore} saved={saved} saving={saving}>
      <form className="form form--inline" onSubmit={onSubmit}>
        <div className="form__horizontal-fields">
          <div className="card__sub-result card__sub-result--shoot form__field form__field--sm">
            <input
              type="number"
              min={0}
              max={100}
              value={data.shootingScoreInput || ''}
              onChange={onChange('shootingScoreInput')}
            />
          </div>
          <div className="card__sub-result card__sub-result--shoot">
            <div className="form__horizontal-fields form__fields--shots">
              {new Array(10).fill(0).map((_, i) => (
                <div className="form__field form__field--xs form__field--shot" key={i}>
                  <input
                    type="number"
                    min={0}
                    max={10}
                    value={data.shots[i]}
                    onChange={onChangeShot('shots', i)}
                    className="shot"
                  />
                </div>
              ))}
            </div>
          </div>
          <div className="form__buttons">
            <Button submit={true} type="primary" disabled={!changed}>{t('save')}</Button>
          </div>
        </div>
      </form>
    </ResultRow>
  )
}

export default ThreeSportsShootingForm
