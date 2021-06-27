import React from 'react'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'
import { buildRelayLegPath, buildRelayPath } from '../../util/routeUtil'

export default function LegButtons({ relay, currentLeg }) {
  const { t } = useTranslation()
  return (
    <div className="buttons">
      {[...Array(relay.legsCount).keys()].map(i => {
        const leg = i + 1
        const text = t('legNumber', { leg })
        if (currentLeg === leg) {
          return <Button key={i} type="current">{text}</Button>
        } else {
          return <Button key={i} href={buildRelayLegPath(relay.id, leg)}>{text}</Button>
        }
      })}
      {currentLeg && <Button href={buildRelayPath(relay.raceId, relay.id)}>{t('finish')}</Button>}
      {!currentLeg && <Button type="current">{t('finish')}</Button>}
    </div>
  )
}
