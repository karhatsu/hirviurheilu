const ScoreInputField = ({ data, field, maxScoreInput, onChange }) => (
  <input
    name="competitor[shooting_score_input]"
    type="number"
    min={0}
    max={maxScoreInput}
    value={data[field] ?? ''}
    onChange={onChange(field)}
  />
)

export default ScoreInputField
