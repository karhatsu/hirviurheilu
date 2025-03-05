import { useCallback, useEffect, useState } from 'react'
import useTitle from "../../util/useTitle"
import useTranslation from "../../util/useTranslation"
import { get, post } from "../../util/apiClient"
import { formatDateInterval } from "../../util/timeUtil"
import IncompletePage from "../../common/IncompletePage"
import Message from "../../common/Message"
import Button from "../../common/Button"
import { useNavigate } from "react-router"
import FormErrors from "../../common/form/FormErrors"
import { buildOfficialEventPath } from "../../util/routeUtil"

const NewEventPage = () => {
  const [fetching, setFetching] = useState(true)
  const [races, setRaces] = useState()
  const [raceErrors, setRaceErrors] = useState([])
  const [raceIds, setRaceIds] = useState([])
  const [name, setName] = useState('')
  const [saving, setSaving] = useState(false)
  const [errors, setErrors] = useState([])
  const { t } = useTranslation()
  useTitle(t('eventsNew'))
  const navigate = useNavigate()

  useEffect(() => {
    get('/official/races.json', (err, response) => {
      if (err) {
        setRaceErrors(err[0])
      } else {
        setRaces(response.races.filter(race => !race.eventId))
      }
      setFetching(false)
    })
  }, [])

  const changeRaceId = useCallback(id => event => {
    setRaceIds(ids => {
      if (event.target.checked) {
        return [...ids, id]
      } else {
        const newIds = [...ids]
        const index = newIds.indexOf(id)
        newIds.splice(index, 1)
        return newIds
      }
    })
  }, [])

  const onSubmit = useCallback(event => {
    event.preventDefault()
    setErrors([])
    setSaving(true)
    post('/official/events', { event: { name }, raceIds }, (err, response) => {
      if (err) {
        setErrors(err)
        setSaving(false)
      } else {
        navigate(buildOfficialEventPath(response.id))
      }
    })
  }, [name, raceIds, navigate])

  if (fetching || raceErrors.length) return <IncompletePage fetching={fetching} error={raceErrors} />

  if (races.length < 2) return (
    <div>
      <Message type="info">{t('eventsAtLeastTwoRaces')}</Message>
      <div className="buttons buttons--nav">
        <Button href="/official" type="back">{t('backToOfficialIndexPage')}</Button>
      </div>
    </div>
  )

  return (
    <div>
      <Message type="info">Valitse vähintään kaksi samaan tapahtumaan kuuluvaa kilpailua</Message>
      <FormErrors errors={errors}/>
      <form className="form" onSubmit={onSubmit}>
        <div className="form__horizontal-fields">
          <div className="form__field">
            <label htmlFor="name">{t('name')}</label>
            <input
              id="name"
              onChange={e => setName(e.target.value)}
              value={name}
            />
          </div>
        </div>
        <div className="form__field">
          <label>{t('races')}</label>
          {races.map(race => {
            const {id, name, location, startDate, endDate} = race
            return (
              <div key={id} className="form__horizontal-fields">
                <div className="form__field">
                  <input
                    type="checkbox"
                    id={`race_${id}`}
                    checked={raceIds.includes(id)}
                    onChange={changeRaceId(id)}
                  />
                  <label htmlFor={`race_${id}`}>
                    {name} {formatDateInterval(startDate, endDate)}, {location}
                  </label>
                </div>
              </div>
            )
          })}
        </div>
        <div className="form__buttons">
          <Button submit={true} type="primary" disabled={!name || raceIds.length < 2 || saving}>
            {t('save')}
          </Button>
        </div>
      </form>
      <div className="buttons buttons--nav">
        <Button href="/official" type="back">{t('backToOfficialIndexPage')}</Button>
      </div>
    </div>
  )
}

export default NewEventPage
