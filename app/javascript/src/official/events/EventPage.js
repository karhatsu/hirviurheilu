import React, { useEffect, useState } from 'react'
import { get } from "../../util/apiClient"
import { useParams } from "react-router"
import IncompletePage from "../../common/IncompletePage"
import useTitle from "../../util/useTitle"
import Button from "../../common/Button"
import useTranslation from "../../util/useTranslation"

const EventPage = () => {
  const { t } = useTranslation()
  const { eventId } = useParams()
  const [event, setEvent] = useState()
  useTitle(event?.name)

  useEffect(() => {
    get(`/official/events/${eventId}.json`, (err, response) => {
      setEvent(response)
    })
  }, [eventId])

  if (!event) return <IncompletePage fetching={true} />

  return (
    <div>
      <h3>{t('eventRaces')}</h3>
      <div>
        {event.races.map(race => <div key={race.id}>{race.name}</div>)}
      </div>
      <div className="buttons buttons--nav">
        <Button href="/official" type="back">{t('backToOfficialIndexPage')}</Button>
      </div>
    </div>
  )
}

export default EventPage
