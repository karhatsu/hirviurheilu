import FormField from "../../common/form/FormField"
import ScoreInputField from "../results/ScoreInputField"
import ShotFields from "../results/ShotFields"
import { shotCount, shotValue } from "../results/resultUtil"
import { useMemo } from "react"

const ShootingRaceShotFields = ({ competitorId, data, onChange, onChangeShot, sport }) => {
  const { qualificationRoundShotCount, finalRoundShotCount, bestShotValue } = sport
  const maxQRScore = qualificationRoundShotCount * shotValue(bestShotValue)
  const maxFRScore = finalRoundShotCount * shotValue(bestShotValue)

  const extraRoundShotCount = useMemo(() => {
    if (data.qualificationRoundShootingScoreInput ||
      [sport.qualificationRoundShotCount, sport.shotCount].includes(shotCount(data.shots))) {
      const currentCount = (data.extraShots || []).length
      return currentCount + sport.shotsPerExtraRound - currentCount % sport.shotsPerExtraRound
    }
    return 0
  }, [sport, data])

  const idPrefix = `shots-shot-${competitorId}`
  return (
    <>
      <FormField id="qualificationRoundShootingScoreInput" size="sm">
        <ScoreInputField
          data={data}
          field="qualificationRoundShootingScoreInput"
          maxScoreInput={maxQRScore}
          onChange={onChange}
          withInfo={true}
        />
      </FormField>
      <FormField id="qualificationRoundShots">
        <ShotFields
          idPrefix={idPrefix}
          data={data}
          shotsField="shots"
          onChangeShot={onChangeShot}
          shotCounts={sport.qualificationRound}
          bestShotValue={sport.bestShotValue}
        />
      </FormField>
      <FormField id="finalRoundShootingScoreInput" size="sm">
        <ScoreInputField
          data={data}
          field="finalRoundShootingScoreInput"
          maxScoreInput={maxFRScore}
          onChange={onChange}
          withInfo={true}
        />
      </FormField>
      <FormField id="finalRoundShots">
        <ShotFields
          idPrefix={idPrefix}
          data={data}
          shotsField="shots"
          onChangeShot={onChangeShot}
          shotCounts={sport.finalRound}
          base={sport.qualificationRoundShotCount}
          bestShotValue={sport.bestShotValue}
        />
      </FormField>
      {extraRoundShotCount > 0 && (
        <FormField id="extraShots">
          <ShotFields
            data={data}
            shotsField="extraShots"
            onChangeShot={onChangeShot}
            shotCounts={[extraRoundShotCount]}
            bestShotValue={sport.bestShotValue}
          />
        </FormField>
      )}
    </>
  )
}

export default ShootingRaceShotFields
