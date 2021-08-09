import React from 'react'
import parseISO from 'date-fns/parseISO'
import useTranslation from '../../util/useTranslation'
import { buildRelayPath } from '../../util/routeUtil'
import Button from '../../common/Button'
import { formatTodaysTime } from '../../util/timeUtil'

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
          const linkText = !started && startTime ? `${name} (${formatTodaysTime(parseISO(startTime))})` : name
          const type = (started || !startTime) && 'primary'
          return <Button key={id} to={buildRelayPath(race.id, id)} type={type}>{linkText}</Button>
        })}
      </div>
    </>
  )
}
