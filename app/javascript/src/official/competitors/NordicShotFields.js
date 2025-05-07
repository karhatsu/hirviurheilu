import { useMemo } from "react"
import FormField from "../../common/form/FormField"
import ScoreInputField from "../results/ScoreInputField"
import ShotFields from "../results/ShotFields"
import { nordicConfig, shotCount as countShots } from "../results/resultUtil"

const SubSportFields = ({ data, onChange, onChangeShot, race, subSport }) => {
  const { fieldNames, shotCount, shotsPerExtraRound, bestShotValue, bestExtraShotValue } = nordicConfig(subSport, race)
  const { scoreInput, shots, extraShots } = fieldNames

  const extraRoundShotCount = useMemo(() => {
    if (data[scoreInput] || countShots(data[shots]) === shotCount) {
      const currentCount = (data[extraShots] || []).length
      return currentCount + shotsPerExtraRound - currentCount % shotsPerExtraRound
    }
    return 0
  }, [data, scoreInput, shots, extraShots, shotCount, shotsPerExtraRound])

  return (
    <>
      <FormField id={scoreInput} size="sm">
        <ScoreInputField
          data={data}
          field={scoreInput}
          maxScoreInput={shotCount * bestShotValue}
          onChange={onChange}
        />
      </FormField>
      <FormField id={shots}>
        <ShotFields
          data={data}
          shotsField={shots}
          onChangeShot={onChangeShot}
          shotCounts={[shotCount]}
          bestShotValue={bestShotValue}
        />
      </FormField>
      {extraRoundShotCount > 0 && (
        <FormField id={extraShots}>
          <ShotFields
            data={data}
            shotsField={extraShots}
            onChangeShot={onChangeShot}
            shotCounts={[extraRoundShotCount]}
            bestShotValue={bestExtraShotValue}
          />
        </FormField>
      )}
    </>
  )
}

const NordicShotFields = ({ data, onChange, onChangeShot, race }) => {
  return ['trap', 'shotgun', 'rifleMoving', 'rifleStanding'].map(subSport => (
    <SubSportFields
      key={subSport}
      data={data}
      onChange={onChange}
      onChangeShot={onChangeShot}
      race={race}
      subSport={subSport}
    />
  ))
}

export default NordicShotFields
