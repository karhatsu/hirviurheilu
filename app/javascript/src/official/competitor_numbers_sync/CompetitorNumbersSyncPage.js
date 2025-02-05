import React, { useCallback, useEffect, useState } from 'react'
import Message from "../../common/Message"
import useTranslation from "../../util/useTranslation"
import Button from "../../common/Button"
import { get, post } from '../../util/apiClient'
import IncompletePage from "../../common/IncompletePage"
import { formatDateInterval } from "../../util/timeUtil"

const CompetitorNumbersSyncPage = () => {
  const [races, setRaces] = useState()
  const [raceIds, setRaceIds] = useState([])
  const [firstNumber, setFirstNumber] = useState(1)
  const [saving, setSaving] = useState(false)
  const [done, setDone] = useState(false)
  const { t } = useTranslation()

  useEffect(() => {
    get('/official/races.json', (err, response) => {
      setRaces(response.races)
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
    setSaving(true)
    post('/official/competitor_number_syncs', { raceIds, firstNumber }, (errors) => {
      if (!errors) {
        setDone(true)
      }
      setSaving(false)
    })
  }, [raceIds, firstNumber])

  if (!races) return <IncompletePage fetching={true} />

  const content = () => {
    if (done) return <Message type="success">{t('competitorNumbersSyncDone')}</Message>
    if (races.length < 2) return <Message type="warning">{t('competitorNumbersSyncNoRaces')}</Message>
    return (
      <form className="form" onSubmit={onSubmit}>
        <label>{t('races')}</label>
        {races.map(race => {
          const { id, name, location, startDate, endDate } = race
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
        <div className="form__field form__field--sm">
          <label htmlFor="firstNumber">{t('firstNumber')}</label>
          <input
            id="firstNumber"
            type="number"
            min={1}
            step={1}
            onChange={e => setFirstNumber(e.target.value)}
            value={firstNumber}
          />
        </div>
        <div className="form__buttons">
          <Button submit={true} type="primary" disabled={raceIds.length < 2 || saving}>
            {t('competitorNumbersSync')}
          </Button>
        </div>
      </form>
    )
  }

  return (
    <div>
      {!done && <Message type="info">{t('competitorNumbersSyncInfo')}</Message>}
      {content()}
      <div className="buttons buttons--nav">
        <Button href="/official" type="back">{t('backToOfficialIndexPage')}</Button>
      </div>
    </div>
  )
}

export default CompetitorNumbersSyncPage
