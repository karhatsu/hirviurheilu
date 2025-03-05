import { useCallback, useEffect, useState } from 'react'
import Button from "../../common/Button"
import { useNavigate, useParams } from "react-router"
import useTranslation from "../../util/useTranslation"
import { put } from "../../util/apiClient"
import FormErrors from "../../common/form/FormErrors"
import useTitle from "../../util/useTitle"
import IncompletePage from "../../common/IncompletePage"
import { buildOfficialEventPath } from "../../util/routeUtil"
import { useEvent } from "../../util/useEvent"

const EditEventPage = () => {
  const { eventId } = useParams()
  const { t } = useTranslation()
  const navigate = useNavigate()
  const [saving, setSaving] = useState(false)
  const [errors, setErrors] = useState([])
  const [data, setData] = useState({ name: '' })
  const { fetching, event, error, reload } = useEvent()
  useTitle(event && [event.name, t('edit')])

  useEffect(() => {
    if (event) setData({ name: event.name })
  }, [event])

  const onChange = useCallback(key => event => {
    setData(prev => ({ ...prev, [key]: event.target.value }))
  }, [])

  const onSubmit = useCallback(e => {
    e.preventDefault()
    setErrors([])
    setSaving(true)
    put(`/official/events/${eventId}`, { event: data }, (err) => {
      if (err) {
        setErrors(err)
        setSaving(false)
      } else {
        reload()
        navigate(buildOfficialEventPath(eventId))
      }
    })
  }, [data, eventId, reload, navigate])

  if (fetching || error) return <IncompletePage fetching={fetching} error={error} />

  return (
    <div>
      <FormErrors errors={errors} />
      <form className="form" onSubmit={onSubmit}>
        <div className="form__horizontal-fields">
          <div className="form__field">
            <label htmlFor="name">{t('name')}</label>
            <input id="name" onChange={onChange('name')} value={data.name} />
          </div>
        </div>
        <div className="form__buttons">
          <Button submit={true} type="primary" disabled={!data.name || saving}>
            {t('save')}
          </Button>
        </div>
      </form>
      <div className="buttons buttons--nav">
        <Button to={buildOfficialEventPath(eventId)} type="back">{t('cancel')}</Button>
      </div>
    </div>
  )
}

export default EditEventPage
