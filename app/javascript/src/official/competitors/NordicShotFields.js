import { useMemo } from "react"
import FormField from "../../common/form/FormField"
import ScoreInputField from "../results/ScoreInputField"
import ShotFields from "../results/ShotFields"
import { shotCount as countShots } from "../results/resultUtil"

const SubSportFields = props => {
  const {
    data,
    scoreInputField,
    shotsField,
    extraShotsField,
    bestShotValue,
    shotCount,
    shotsPerExtraRound,
    onChange,
    onChangeShot,
  } = props

  const extraRoundShotCount = useMemo(() => {
    if (data[scoreInputField] || countShots(data[shotsField]) === shotCount) {
      const currentCount = (data[extraShotsField] || []).length
      return currentCount + shotsPerExtraRound - currentCount % shotsPerExtraRound
    }
    return 0
  }, [data, scoreInputField, shotsField, extraShotsField, shotCount, shotsPerExtraRound])

  return (
    <>
      <FormField id={scoreInputField} size="sm">
        <ScoreInputField
          data={data}
          field={scoreInputField}
          maxScoreInput={shotCount * bestShotValue}
          onChange={onChange}
        />
      </FormField>
      <FormField id={shotsField}>
        <ShotFields
          data={data}
          shotsField={shotsField}
          onChangeShot={onChangeShot}
          shotCounts={[shotCount]}
          bestShotValue={bestShotValue}
        />
      </FormField>
      {extraRoundShotCount > 0 && (
        <FormField id={extraShotsField}>
          <ShotFields
            data={data}
            shotsField={extraShotsField}
            onChangeShot={onChangeShot}
            shotCounts={[extraRoundShotCount]}
            bestShotValue={bestShotValue}
          />
        </FormField>
      )}
    </>
  )
}

const NordicShotFields = ({ data, onChange, onChangeShot }) => {
  return (
    <>
      <SubSportFields
        data={data}
        scoreInputField="nordicTrapScoreInput"
        shotsField="nordicTrapShots"
        extraShotsField="nordicTrapExtraShots"
        bestShotValue={1}
        shotCount={25}
        shotsPerExtraRound={1}
        onChange={onChange}
        onChangeShot={onChangeShot}
      />
      <SubSportFields
        data={data}
        scoreInputField="nordicShotgunScoreInput"
        shotsField="nordicShotgunShots"
        extraShotsField="nordicShotgunExtraShots"
        bestShotValue={1}
        shotCount={25}
        shotsPerExtraRound={1}
        onChange={onChange}
        onChangeShot={onChangeShot}
      />
      <SubSportFields
        data={data}
        scoreInputField="nordicRifleMovingScoreInput"
        shotsField="nordicRifleMovingShots"
        extraShotsField="nordicRifleMovingExtraShots"
        bestShotValue={10}
        shotCount={10}
        shotsPerExtraRound={2}
        onChange={onChange}
        onChangeShot={onChangeShot}
      />
      <SubSportFields
        data={data}
        scoreInputField="nordicRifleStandingScoreInput"
        shotsField="nordicRifleStandingShots"
        extraShotsField="nordicRifleStandingExtraShots"
        bestShotValue={10}
        shotCount={10}
        shotsPerExtraRound={2}
        onChange={onChange}
        onChangeShot={onChangeShot}
      />
    </>
  )
}

export default NordicShotFields
