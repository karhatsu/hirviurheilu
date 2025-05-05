import FormField from "../../common/form/FormField"
import useTranslation from "../../util/useTranslation"
import ShotFields from "../results/ShotFields"
import ScoreInputField from "../results/ScoreInputField"

const EstimateField = ({ number, data, onChange }) => {
  const { t } = useTranslation()
  const field = `estimate${number}`
  return (
    <FormField id={field} label={`${t('estimate')} ${number}`} size="sm">
      <input
        id={field}
        type="number"
        maxLength={3}
        min={1}
        value={data[field]}
        onChange={onChange(field)}
        name={`competitor[${field}]`}
      />
    </FormField>
  )
}

const ThreeSportResultFields = ({ competitorId, data, onChange, onChangeShot, fourEstimates }) => (
  <>
    <FormField id="arrivalTime" size="md">
      <input
        id="arrivalTime"
        value={data.arrivalTime || ''}
        onChange={onChange('arrivalTime')}
        placeholder="HH:MM:SS"
      />
    </FormField>
    <FormField id="shootingScoreInput" size="sm">
      <ScoreInputField
        data={data}
        field="shootingScoreInput"
        maxScoreInput={100}
        onChange={onChange}
        withInfo={true}
      />
    </FormField>
    <FormField id="shots">
      <ShotFields
        idPrefix={`shot-${competitorId}`}
        data={data}
        shotsField="shots"
        onChangeShot={onChangeShot}
        shotCounts={[10]}
        bestShotValue={10}
      />
    </FormField>
    <EstimateField number={1} data={data} onChange={onChange} />
    <EstimateField number={2} data={data} onChange={onChange} />
    {fourEstimates && <EstimateField number={3} data={data} onChange={onChange}/>}
    {fourEstimates && <EstimateField number={4} data={data} onChange={onChange}/>}
  </>
)

export default ThreeSportResultFields
