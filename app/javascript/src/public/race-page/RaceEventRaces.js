import React, { useEffect, useMemo, useState } from 'react'
import { get } from "../../util/apiClient"
import Button from "../../common/Button"
import { buildRacePath } from "../../util/routeUtil"
import useTranslation from "../../util/useTranslation"

const RaceEventRaces = ({ race }) => {
  const { id, eventId } = race
  const [event, setEvent] = useState()
  const { t } = useTranslation()

  useEffect(() => {
    if (!eventId) return
    get(`/api/v2/public/events/${eventId}.json`, (err, data) => {
      if (err) return setError(err)
      setEvent(data)
    })
  }, [eventId])

  const races = useMemo(() => {
    return event?.races.filter(race => race.id !== id) || []
  }, [event, id])

  if (races.length) {
    return (
      <div>
        <h2>{t('eventOtherRaces')}</h2>
        <div className="buttons">
          {races.map(race => <Button key={race.id} to={buildRacePath(race.id)}>{race.name}</Button>)}
        </div>
      </div>
    )
  }
}

export default RaceEventRaces
