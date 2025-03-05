import { createContext, useCallback, useContext, useEffect, useState } from 'react'
import { usePathParams } from '../public/PathParamsProvider'
import { get } from './apiClient'

const EventContext = createContext({})

export const useEvent = () => useContext(EventContext)

export const EventProvider = ({ children }) => {
  const { eventId } = usePathParams()
  const [event, setEvent] = useState()
  const [error, setError] = useState()

  const fetchEvent = useCallback(() => {
    get(`/api/v2/public/events/${eventId}.json`, (err, data) => {
      if (err) return setError(err)
      setEvent(data)
    })
  }, [eventId])

  useEffect(() => {
    if (eventId) {
      fetchEvent()
    }
  }, [eventId, fetchEvent])

  const value = { fetching: !error && !event, event, error, reload: fetchEvent }
  return <EventContext value={value}>{children}</EventContext>
}
