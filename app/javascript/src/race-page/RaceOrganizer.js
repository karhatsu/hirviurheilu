import React from 'react'
import useTranslation from '../util/useTranslation'

const urlWithProtocol = url => {
  return url.indexOf('http') === 0 ? url : `http://${url}`
}

export default function RaceOrganizer({ race }) {
  const { t } = useTranslation()
  const { address, cancelled, homePage, organizer, organizerPhone } = race

  if (!homePage && !organizer && !organizerPhone) return null

  const homePageText = organizer || t('raceHomePage')
  const googleUrl = address && `https://www.google.fi/maps/place/${encodeURIComponent(address)}`
  return (
    <>
      <h2 className={cancelled ? 'cancelled-race-first-header' : ''}>{t('raceOrganizer')}</h2>
      <div className="race-organizer">
        {homePage && <a href={urlWithProtocol(homePage)} target="_blank" rel="noreferrer">{homePageText}</a>}
        {!homePage && organizer && <span>{organizer}</span>}
        {address && <a href={googleUrl} target="_blank" rel="noreferrer">{address}</a>}
        {organizerPhone && <span>{organizerPhone}</span>}
      </div>
    </>
  )
}
