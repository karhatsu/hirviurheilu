import useTranslation from '../../util/useTranslation'
import Message from '../../common/Message'
import { useCallback, useState } from 'react'
import Button from '../../common/Button'
import { post } from '../../util/apiClient'
import FormErrors from '../../common/form/FormErrors'

const ResultSection = ({ raceId, titleKey, instructionsKey, field, path, showShotCount }) => {
  const { t } = useTranslation()
  const [value, setValue] = useState('')
  const [saving, setSaving] = useState(false)
  const [successMessage, setSuccessMessage] = useState()
  const [errors, setErrors] = useState()

  const onSubmit = useCallback(
    (e) => {
      e.preventDefault()
      setSuccessMessage()
      setErrors()
      setSaving(true)
      const url = `/official/races/${raceId}/${path}`
      const body = { string: value }
      post(url, body, (err, response) => {
        if (err) {
          setErrors(err)
        } else {
          setSuccessMessage(response.success)
          setValue('')
        }
        setSaving(false)
      })
    },
    [raceId, path, value],
  )

  const shotCount = (value.split(',')[1] || value.split('#')[1])?.length

  return (
    <div>
      <h3>{t(titleKey)}</h3>
      <Message type="info">{t(instructionsKey)}</Message>
      {successMessage && <Message type="success">{successMessage}</Message>}
      {errors && <FormErrors errors={errors} />}
      <form className="form" onSubmit={onSubmit}>
        <div className="form__horizontal-fields">
          <div className="form__field">
            <input type="tel" id={`${field}_string`} value={value} onChange={(e) => setValue(e.target.value)} />
          </div>
          <div className="form__buttons">
            <Button id={`submit_${field}`} submit={true} type="primary" disabled={saving || !value}>
              {t('save')}
            </Button>
          </div>
          {showShotCount && shotCount > 3 && <div className="form__field">({shotCount})</div>}
        </div>
      </form>
    </div>
  )
}

export default ResultSection
