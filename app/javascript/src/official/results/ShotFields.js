import Button from "../../common/Button"
import useTranslation from "../../util/useTranslation"
import { useCallback } from "react"

const BinaryShotField = ({ fieldValue, index, value, onClick }) => {
  const classes = ['binary-shot__option', `binary-shot__option--${fieldValue}`]
  if (fieldValue === value) classes.push('binary-shot__option--selected')
  const newValue = value === fieldValue ? '' : fieldValue
  const handleClick = () => onClick({ target: { value: newValue } })
  return <div className={classes.join(' ')} onClick={handleClick}>{index + 1}</div>
}

const ShotFields = props => {
  const { t } = useTranslation()
  const {
    idPrefix,
    data,
    shotsField,
    base,
    onChangeShot,
    shotCounts,
    bestShotValue,
  } = props

  const selectAll = useCallback(() => {
    shotCounts.forEach((n, i) => {
      new Array(n).fill(0).forEach((_, j) => {
        const counter = (base || 0) + (i === 0 ? j : (i * shotCounts[i - 1]) + j)
        onChangeShot(shotsField, counter)({ target: { value: bestShotValue } })
      })
    })
  }, [shotCounts, base, shotsField, bestShotValue, onChangeShot])

  return (
    <div className="form__horizontal-fields form__fields--shots">
      {shotCounts.map((n, i) => {
        return new Array(n).fill(0).map((_, j) => {
          const counter = (base || 0) + (i === 0 ? j : (i * shotCounts[i - 1]) + j)
          const classes = ['form__field', 'form__field--xs', 'form__field--shot']
          if (j + 1 === n) classes.push('form__field--last-in-group')
          const value = data[shotsField]?.[counter] ?? ''
          return (
            <div className={classes.join(' ')} key={j}>
              {bestShotValue === 1 && (
                <div className="binary-shot">
                  {[0, 1].map(fieldValue => (
                    <BinaryShotField
                      key={fieldValue}
                      fieldValue={fieldValue}
                      index={j}
                      value={value}
                      onClick={onChangeShot(shotsField, counter)}
                    />
                  ))}
                </div>
              )}
              {bestShotValue !== 1 && (
                <input
                  id={`${idPrefix}-${counter}`}
                  type="number"
                  min={0}
                  max={bestShotValue}
                  value={value}
                  onChange={onChangeShot(shotsField, counter)}
                  className="shot"
                />
              )}
            </div>
          )
        })
      })}
      {bestShotValue === 1 && !shotsField.match(/extraShots/i) && (
        <Button type="select-all-shots" onClick={selectAll}>{t('selectAll')}</Button>
      )}
    </div>
  )
}

export default ShotFields
