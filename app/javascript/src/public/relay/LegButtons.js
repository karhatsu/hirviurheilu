import React from 'react'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'
import { buildRelayLegPath, buildRelayPath } from '../../util/routeUtil'

export default function LegButtons({ relay, currentLeg }) {
  const { t } = useTranslation()
  const { raceId, id: relayId, legsCount } = relay
  return (
    <div className="buttons">
      {[...Array(legsCount).keys()].map(i => {
        const leg = i + 1
        const text = t('legNumber', { leg })
        if (currentLeg === leg) {
          return <Button key={i} type="current">{text}</Button>
        } else {
          return <Button key={i} to={buildRelayLegPath(raceId, relayId, leg)}>{text}</Button>
        }
      })}
      {currentLeg && <Button to={buildRelayPath(raceId, relayId)}>{t('finish')}</Button>}
      {!currentLeg && <Button type="current">{t('finish')}</Button>}
    </div>
  )
}
