import { useEffect } from 'react'
import useAppData from './useAppData'
import useTranslation from './useTranslation'

const buildTitle = stringOrArray => {
  if (Array.isArray(stringOrArray)) {
    return stringOrArray.concat('Hirviurheilu').join(' - ')
  } else if (stringOrArray.indexOf('Hirviurheilu') === 0) {
    return stringOrArray
  }
  return `${stringOrArray} - Hirviurheilu`
}

const buildEventJson = (race, t) => ({
  '@context': 'https://schema.org',
  '@type': 'Event',
  name: race.name,
  startDate: race.startDate,
  endDate: race.endDate,
  eventAttendanceMode: 'https://schema.org/OfflineEventAttendanceMode',
  eventStatus: race.cancelled ? 'https://schema.org/EventCancelled' : 'https://schema.org/EventScheduled',
  location: {
    '@type': 'Place',
    name: race.location,
    address: {
      '@type': 'PostalAddress',
      streetAddress: race.address,
      addressCountry: 'FI',
    },
  },
  image: [
    'https://www.hirviurheilu.com/logo-1024.png',
  ],
  description: t(`sport_${race.sportKey}`),
  organizer: {
    '@type': 'Organization',
    name: race.organizer,
    url: race.homePage,
  },
})

const useTitle = (stringOrArray, race) => {
  const { titlePrefix } = useAppData()
  const { t } = useTranslation()

  useEffect(() => {
    if (stringOrArray) {
      document.title = `${titlePrefix}${buildTitle(stringOrArray)}`
    }
  }, [stringOrArray, titlePrefix])

  useEffect(() => {
    const eventElement = document.getElementById('event-data-json')
    let event = ''
    if (race) {
      event = JSON.stringify(buildEventJson(race, t))
    }
    eventElement.innerText = event
  }, [race, t])
}

export default useTitle
