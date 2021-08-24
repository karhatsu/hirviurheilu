import React, { useCallback, useEffect, useState } from 'react'
import { pages } from '../menu/DesktopSecondLevelMenu'
import useTranslation from '../../util/useTranslation'
import useTitle from '../../util/useTitle'
import Message from '../../common/Message'
import { get, post } from '../../util/apiClient'
import Button from '../../common/Button'
import { buildRootPath } from '../../util/routeUtil'
import { formatDateInterval } from '../../util/timeUtil'
import ThankYouView from './ThankYouView'
import useAppData from '../../util/useAppData'

export default function FeedbackPage({ setSelectedPage }) {
  const { t } = useTranslation()
  const { userEmail, userFirstName, userLastName } = useAppData()
  const [form, setForm] = useState({ email: userEmail, name: userFirstName && `${userFirstName} ${userLastName}` })
  const [races, setRaces] = useState([])
  const [sent, setSent] = useState(false)
  const [error, setError] = useState(undefined)

  useEffect(() => setSelectedPage(pages.info.feedback), [setSelectedPage])
  useTitle(t('sendFeedback'))
  useEffect(() => {
    // eslint-disable-next-line node/handle-callback-err
    get('/api/v2/public/recent_races', (err, data) => {
      if (data?.races) {
        setRaces(data.races)
      }
    })
  }, [])

  const submit = useCallback(event => {
    event.preventDefault()
    post('/api/v2/public/feedbacks', form, err => {
      if (err) {
        setError(err)
      } else {
        setSent(true)
      }
    })
  }, [form])

  const setValue = useCallback(field => event => setForm(f => ({ ...f, [field]: event.target.value })), [])

  if (sent) {
    return <ThankYouView />
  }
  return (
    <div>
      <Message type="info">{t('feedbackRaceInfo')}</Message>
      {error && <Message type="error">{error}</Message>}
      <form onSubmit={submit}>
        <div className="form__field">
          <label htmlFor="race_id">{t('feedbackReceiver')}</label>
          <select id="race_id" value={form.race_id} onChange={setValue('race_id')}>
            <option>- {t('feedbackReceiverCommon')} -</option>
            {races.map(race => {
              const { id, name, startDate, endDate, location } = race
              return (
                <option value={id} key={id}>
                  {name} ({formatDateInterval(startDate, endDate)}, {location})
                </option>
              )
            })}
          </select>
        </div>
        <div className="form__field">
          <label htmlFor="comment">{t('feedback')} (*)</label>
          <textarea id="comment" value={form.comment} onChange={setValue('comment')} cols={60} rows={8} />
        </div>
        <div className="form__field">
          <label htmlFor="name">{t('name')}</label>
          <input id="name" value={form.name || ''} onChange={setValue('name')} />
        </div>
        <div className="form__field">
          <label htmlFor="email">{t('email')}</label>
          <input id="email" type="email" value={form.email || ''} onChange={setValue('email')} />
        </div>
        <div className="form__field">
          <label htmlFor="tel">{t('tel')}</label>
          <input id="tel" type="tel" value={form.tel || ''} onChange={setValue('tel')} />
        </div>
        <div className="form__field">
          <label htmlFor="captcha">{t('captchaQuestion')} (*)</label>
          <input id="captcha" value={form.captcha || ''} onChange={setValue('captcha')} />
          <div className="form__field__info">{t('captchaInfo')}</div>
        </div>
        <div className="form__buttons">
          <Button type="primary" submit disabled={!form.comment || !form.captcha}>{t('send')}</Button>
        </div>
      </form>
      <div className="buttons buttons--nav">
        <Button to={buildRootPath()} type="back">{t('backToHomePage')}</Button>
      </div>
    </div>
  )
}
