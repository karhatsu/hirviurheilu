import useTranslation from "../../util/useTranslation"
import useCompetitorResultSaving from "./useCompetitorResultSaving"
import { useMemo } from "react"
import ResultRow from "./ResultRow"
import Button from "../../common/Button"
import { calculateShootingScore, shotCount, shotValue } from "./resultUtil"
import ShotFields from "./ShotFields"

const buildFields = sport => [
  { key: 'qualificationRoundShootingScoreInput', number: true },
  { key: 'finalRoundShootingScoreInput', number: true },
  { key: 'shots', shotCount: sport.qualificationRoundShotCount + sport.finalRoundShotCount },
  { key: 'extraShots', shotCount: 0 },
]

const buildBody = (_, data) => {
  return {
    competitor: {
      qualificationRoundShootingScoreInput: data.qualificationRoundShootingScoreInput,
      finalRoundShootingScoreInput: data.finalRoundShootingScoreInput,
    },
    shots: data.shots,
    extraShots: data.extraShots,
  }
}

export const limits = {
  qr: 1,
  final: 2,
}

const ShootingRaceShootingForm = ({ competitor: initialCompetitor, sport, limit }) => {
  const { t } = useTranslation()
  const fields = useMemo(() => buildFields(sport), [sport])
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

  const { qualificationRoundShotCount, finalRoundShotCount, bestShotValue } = sport
  const maxQRScore = qualificationRoundShotCount * shotValue(bestShotValue)
  const maxFRScore = finalRoundShotCount * shotValue(bestShotValue)

  const score = useMemo(() => {
    const { qualificationRoundShotCount } = sport
    const {
      qualificationRoundShootingScoreInput: qrScoreInput,
      finalRoundShootingScoreInput: finScoreInput,
      shots,
    } = data
    const qrScore = calculateShootingScore(qrScoreInput, shots.slice(0, qualificationRoundShotCount), maxQRScore)
    const finScore = calculateShootingScore(finScoreInput, shots.slice(qualificationRoundShotCount), maxFRScore)
    if (limit === limits.final) return finScore
    if (qrScore === '' || qrScore === '?' || limit === limits.qr) return qrScore
    if (finScore === '') return qrScore
    if (finScore === '?') return '?'
    return `${qrScore} + ${finScore} = ${qrScore + finScore}`
  }, [data, sport, maxQRScore, maxFRScore, limit])

  const extraRoundShotCount = useMemo(() => {
    if (data.qualificationRoundShootingScoreInput ||
      [sport.qualificationRoundShotCount, sport.shotCount].includes(shotCount(data.shots))) {
      const currentCount = (data.extraShots || []).length
      return currentCount + sport.shotsPerExtraRound - currentCount % sport.shotsPerExtraRound
    }
    return 0
  }, [sport, data])

  const idPrefix = `shots-shot-${competitor.id}`
  return (
    <ResultRow competitor={competitor} errors={errors} result={score} saved={saved} saving={saving}>
      <form className="form form--inline" onSubmit={onSubmit}>
        {!limit && <div className="form__subtitle">{t('qualificationRound')}</div>}
        {(!limit || limit === limits.qr) && (
          <div className="form__horizontal-fields">
            <ShotFields
              idPrefix={idPrefix}
              data={data}
              scoreInputField="qualificationRoundShootingScoreInput"
              shotsField="shots"
              maxScoreInput={maxQRScore}
              onChange={onChange}
              onChangeShot={onChangeShot}
              shotCounts={sport.qualificationRound}
              bestShotValue={sport.bestShotValue}
            />
          </div>
        )}
        {(!limit || limit === limits.final) && (
          <>
            <div className="form__subtitle">{t('finalRound')}</div>
            <div className="form__horizontal-fields">
              <ShotFields
                idPrefix={idPrefix}
                data={data}
                scoreInputField="finalRoundShootingScoreInput"
                shotsField="shots"
                maxScoreInput={maxFRScore}
                onChange={onChange}
                onChangeShot={onChangeShot}
                shotCounts={sport.finalRound}
                base={sport.qualificationRoundShotCount}
                bestShotValue={sport.bestShotValue}
              />
            </div>
            {extraRoundShotCount > 0 && (
              <>
                <div className="form__subtitle">{t('extraRound')}</div>
                <ShotFields
                  idPrefix={`shots-extra-${competitor.id}`}
                  data={data}
                  shotsField="extraShots"
                  onChangeShot={onChangeShot}
                  shotCounts={[extraRoundShotCount]}
                  bestShotValue={sport.bestShotValue}
                />
              </>
            )}
          </>
        )}
        <div className="form__buttons">
          <Button submit={true} type="primary" disabled={!changed}>{t('save')}</Button>
        </div>
      </form>
    </ResultRow>
  )
}

export default ShootingRaceShootingForm
