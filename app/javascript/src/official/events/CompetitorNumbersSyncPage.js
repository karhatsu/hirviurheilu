import React, { useCallback, useEffect, useState } from 'react'
import isBefore from 'date-fns/isBefore'
import isToday from 'date-fns/isToday'
import Message from "../../common/Message"
import useTranslation from "../../util/useTranslation"
import Button from "../../common/Button"
import { put } from '../../util/apiClient'
import useOfficialMenu from "../menu/useOfficialMenu"
import { pages } from "../../util/useMenu"
import { useParams } from "react-router"
import { buildOfficialEventPath } from "../../util/routeUtil"
import { useEvent } from "../../util/useEvent"
import IncompletePage from "../../common/IncompletePage"

const CompetitorNumbersSyncPage = () => {
  const { eventId } = useParams()
  const [firstNumber, setFirstNumber] = useState(1)
  const [saving, setSaving] = useState(false)
  const [done, setDone] = useState(false)
  const { t } = useTranslation()
  const { setSelectedPage } = useOfficialMenu()
  const { fetching, error, event } = useEvent()

  useEffect(() => setSelectedPage(pages.events.syncNumbers), [setSelectedPage])

  const onSubmit = useCallback(event => {
    event.preventDefault()
    setSaving(true)
    put(`/official/events/${eventId}/competitor_numbers_sync`, { firstNumber }, (errors) => {
      if (!errors) {
        setDone(true)
      }
      setSaving(false)
    })
  }, [eventId, firstNumber])

  if (fetching || error) return <IncompletePage fetching={fetching} error={error} />

  const hasThreeSportsRace = !!event.races.find(race => race.sportKey === 'SKI' || race.sportKey === 'RUN')
  const hasStartedRace = !!event.races.find(race => isBefore(race.startDate, new Date()) || isToday(race.startDate))

  const content = () => {
    if (hasThreeSportsRace) return <Message type="warning">{t('competitorNumbersSyncInvalidRaces')}</Message>
    if (hasStartedRace) return <Message type="warning">{t('competitorNumbersSyncRaceStarted')}</Message>
    if (done) return <Message type="success">{t('competitorNumbersSyncDone')}</Message>
    return (
      <form className="form" onSubmit={onSubmit}>
        <Message type="info">{t('competitorNumbersSyncInfo')}</Message>
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
          <Button submit={true} type="primary" disabled={saving}>
            {t('competitorNumbersSync')}
          </Button>
        </div>
      </form>
    )
  }

  return (
    <div>
      <h2>{t('officialEventMenuSyncNumbers')}</h2>
      {content()}
      <div className="buttons buttons--nav">
        <Button to={buildOfficialEventPath(eventId)} type="back">{t('backToOfficialEventPage')}</Button>
      </div>
    </div>
  )
}

export default CompetitorNumbersSyncPage
