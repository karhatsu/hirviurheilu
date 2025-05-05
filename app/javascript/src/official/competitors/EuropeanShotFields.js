import FormField from "../../common/form/FormField"
import ScoreInputField from "../results/ScoreInputField"
import ShotFields from "../results/ShotFields"
import { useMemo } from "react"
import useTranslation from "../../util/useTranslation"

const SubSportFields = props => {
  const { t } = useTranslation()
  const {
    data,
    scoreInputField,
    shotsField,
    onChange,
    onChangeShot,
    shotCount,
    bestShotValue,
    doubleCompetition,
  } = props
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
      {doubleCompetition && (
        <>
          <FormField id={scoreInputField + '2'} label={t(scoreInputField) + ' (2)'} size="sm">
            <ScoreInputField
              data={data}
              field={scoreInputField + '2'}
              maxScoreInput={shotCount * bestShotValue}
              onChange={onChange}
            />
          </FormField>
          <FormField id={shotsField + '2'} label={t(shotsField) + ' (2)'}>
            <ShotFields
              data={data}
              shotsField={shotsField + '2'}
              onChangeShot={onChangeShot}
              shotCounts={[shotCount]}
              bestShotValue={bestShotValue}
            />
          </FormField>
        </>
      )}
    </>
  )
}

const EuropeanShotFields = ({ data, doubleCompetition, onChange, onChangeShot }) => {
  const europeanRifleExtraShotCount = useMemo(() => {
    const currentCount = (data.europeanRifleExtraShots || []).length
    return currentCount + 5 - currentCount % 5
  }, [data.europeanRifleExtraShots])

  return (
    <>
      {['Trap', 'Compak'].map(subSport => (
        <SubSportFields
          key={subSport}
          data={data}
          onChange={onChange}
          onChangeShot={onChangeShot}
          scoreInputField={`european${subSport}ScoreInput`}
          shotsField={`european${subSport}Shots`}
          shotCount={25}
          bestShotValue={1}
          doubleCompetition={doubleCompetition}
        />
      ))}
      {[1, 2, 3, 4].map(n => (
        <SubSportFields
          key={n}
          data={data}
          onChange={onChange}
          onChangeShot={onChangeShot}
          scoreInputField={`europeanRifle${n}ScoreInput`}
          shotsField={`europeanRifle${n}Shots`}
          shotCount={5}
          bestShotValue={10}
          doubleCompetition={doubleCompetition}
        />
      ))}
      <FormField id="europeanShotgunExtraScore" size="sm">
        <ScoreInputField data={data} field="europeanShotgunExtraScore" onChange={onChange} />
      </FormField>
      <FormField id="europeanRifleExtraShots">
        <ShotFields
          data={data}
          shotsField="europeanRifleExtraShots"
          onChangeShot={onChangeShot}
          shotCounts={[europeanRifleExtraShotCount]}
          bestShotValue={10}
        />
      </FormField>
      <FormField id="europeanExtraScore" size="sm">
        <ScoreInputField data={data} field="europeanExtraScore" onChange={onChange} />
      </FormField>
    </>
  )
}

export default EuropeanShotFields
