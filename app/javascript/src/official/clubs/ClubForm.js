import { useCallback, useState } from 'react'
import Button from '../../common/Button'
import useTranslation from '../../util/useTranslation'
import FormErrors from '../../common/form/FormErrors'

const ClubForm = ({ title, initialData, errors, onSave, onCancel }) => {
  const { t } = useTranslation()
  const [data, setData] = useState(initialData)
  const onChange = useCallback(field => event => setData(d => ({ ...d, [field]: event.target.value })), [])
  const onSubmit = useCallback(event => {
    event.preventDefault()
    onSave(data)
  }, [onSave, data])
  return (
    <div>
      <h2>{title}</h2>
      <FormErrors errors={errors} />
      <form className="form" onSubmit={onSubmit}>
        <div className="form__field">
          <label htmlFor="name">{t('name')}</label>
          <input id="name" type="text" value={data.name} onChange={onChange('name')} />
        </div>
        <div className="form__field">
          <label htmlFor="longName">{t('longName')}</label>
          <input id="longName" type="text" value={data.longName || ''} onChange={onChange('longName')} />
          <div className="form__field__info">{t('clubsLongNameInfo')}</div>
        </div>
        <div className="form__buttons">
          <Button submit={true} type="primary">{t('save')}</Button>
        </div>
      </form>
      <div className="buttons buttons--nav">
        <Button onClick={onCancel}>{t('cancel')}</Button>
      </div>
    </div>
  )
}

export default ClubForm
