import React from 'react'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'

const urlWithProtocol = url => {
  return url.indexOf('http') === 0 ? url : `http://${url}`
}

export default function RaceOrganizer({ race }) {
  const { t } = useTranslation()
  const { address, cancelled, homePage, organizer, organizerPhone } = race

  if (!address && !homePage && !organizer && !organizerPhone) return null

  const googleUrl = address && `https://www.google.fi/maps/place/${encodeURIComponent(address)}`
  const mainText = [organizer, address, organizerPhone].filter(i => i).join(', ')
  return (
    <>
      <h2 className={cancelled ? 'cancelled-race-first-header' : ''}>{t('raceOrganizer')}</h2>
      {organizer && <div className="race-organizer">{mainText}</div>}
      {(homePage || address || organizerPhone) && (
        <div className="buttons">
          {homePage && <Button href={urlWithProtocol(homePage)} type="open" blank={true}>{t('raceHomePage')}</Button>}
          {googleUrl && <Button href={googleUrl} type="place" blank={true}>{t('navigate')}</Button>}
          {organizerPhone && <Button href={`tel:${organizerPhone}`} type="call">{organizerPhone}</Button>}
        </div>
      )}
    </>
  )
}
