import React, { useCallback, useContext, useEffect, useState } from 'react'
import { usePathParams } from '../public/PathParamsProvider'
import { get } from './apiClient'

const EventContext = React.createContext({})

export const useEvent = () => useContext(EventContext)

export const EventProvider = ({ children }) => {
  const { eventId } = usePathParams()
  const [event, setEvent] = useState()
  const [error, setError] = useState()

  const fetchEvent = useCallback(() => {
    // NOTE: for now official route
    get(`/official/events/${eventId}.json`, (err, data) => {
      if (err) return setError(err)
      setEvent(data)
    })
  }, [eventId])

  useEffect(() => {
    if (eventId) {
      fetchEvent()
    }
  }, [eventId, fetchEvent])

  const value = { fetching: !error && !event, event, error }
  return <EventContext value={value}>{children}</EventContext>
}
