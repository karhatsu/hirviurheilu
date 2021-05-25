import React from 'react'
import useTranslation from '../../util/useTranslation'
import { buildRelayPath } from '../../util/routeUtil'
import format from 'date-fns/format'
import parseISO from 'date-fns/parseISO'

export default function RaceRelays({ race }) {
  const { t } = useTranslation()
  const { relays } = race
  if (!relays.length) return null
  return (
    <>
      <h2>{t('relays')}</h2>
      <div className="buttons">
        {relays.map(relay => {
          const { id, name, started, startTime } = relay
          const linkText = !started && startTime ? `${name} (${format(parseISO(startTime), 'HH:mm')})` : name
          const className = !started && startTime ? 'button' : 'button button--primary'
          return <a key={id} href={buildRelayPath(race.id, id)} className={className}>{linkText}</a>
        })}
      </div>
    </>
  )
}
