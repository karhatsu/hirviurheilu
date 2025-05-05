import useTranslation from "../../util/useTranslation"

const ScoreInputField = ({ data, field, maxScoreInput, onChange, withInfo }) => {
  const { t } = useTranslation()
  return (
    <>
      <input
        id={field}
        name="competitor[shooting_score_input]"
        type="number"
        min={0}
        max={maxScoreInput}
        value={data[field] ?? ''}
        onChange={onChange(field)}
      />
      {withInfo && ` (${t('eitherTotalScoreOrShots')})`}
    </>
  )
}

export default ScoreInputField
