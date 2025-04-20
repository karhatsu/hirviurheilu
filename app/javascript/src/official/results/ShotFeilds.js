const ShotFields = ({ data, scoreInputField, shotsField, base, onChange, onChangeShot, maxScoreInput, shotCounts }) => {
  return (
    <>
      {scoreInputField && (
        <div className="card__sub-result card__sub-result--shoot form__field form__field--sm">
          <input
            type="number"
            min={0}
            max={maxScoreInput}
            value={data[scoreInputField] || ''}
            onChange={onChange(scoreInputField)}
          />
        </div>
      )}
      <div className="card__sub-result card__sub-result--shoot">
        <div className="form__horizontal-fields form__fields--shots">
          {shotCounts.map((n, i) => {
            return new Array(n).fill(0).map((_, j) => {
              const counter = (base || 0) + (i === 0 ? j : (i * shotCounts[i - 1]) + j)
              const classes = ['form__field', 'form__field--xs', 'form__field--shot']
              if (j + 1 === n) classes.push('form__field--last-in-group')
              return (
                <div className={classes.join(' ')} key={j}>
                  <input
                    type="number"
                    min={0}
                    max={10}
                    value={data[shotsField]?.[counter] || ''}
                    onChange={onChangeShot(shotsField, counter)}
                    className="shot"
                  />
                </div>
              )
            })
          })}
        </div>
      </div>
    </>
  )
}

export default ShotFields
