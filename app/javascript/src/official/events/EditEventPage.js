import React, { useCallback, useEffect, useState } from 'react'
import Button from "../../common/Button"
import { useNavigate, useParams } from "react-router"
import useTranslation from "../../util/useTranslation"
import { get, put } from "../../util/apiClient"
import FormErrors from "../../common/form/FormErrors"
import useTitle from "../../util/useTitle"
import IncompletePage from "../../common/IncompletePage"
import { buildOfficialEventPath } from "../../util/routeUtil"

const EditEventPage = () => {
  const { eventId } = useParams()
  const { t } = useTranslation()
  const navigate = useNavigate()
  const [saving, setSaving] = useState(false)
  const [errors, setErrors] = useState([])
  const [event, setEvent] = useState()
  useTitle(event && [event.name, t('edit')])

  useEffect(() => {
    get(`/official/events/${eventId}.json`, (err, response) => {
      setEvent(response)
    })
  }, [eventId])

  const onChange = useCallback(key => event => {
    setEvent(prev => ({ ...prev, [key]: event.target.value }))
  }, [])

  const onSubmit = useCallback(e => {
    e.preventDefault()
    setErrors([])
    setSaving(true)
    put(`/official/events/${eventId}`, { event: { name: event.name } }, (err) => {
      if (err) {
        setErrors(err)
        setSaving(false)
      } else {
        navigate(buildOfficialEventPath(eventId))
      }
    })
  }, [event, eventId, navigate])

  if (!event) return <IncompletePage fetching={true} />

  return (
    <div>
      <FormErrors errors={errors} />
      <form className="form" onSubmit={onSubmit}>
        <div className="form__horizontal-fields">
          <div className="form__field">
            <label htmlFor="name">{t('name')}</label>
            <input id="name" onChange={onChange('name')} value={event.name} />
          </div>
        </div>
        <div className="form__buttons">
          <Button submit={true} type="primary" disabled={!event.name || saving}>
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
