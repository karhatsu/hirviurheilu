import React from 'react'
import format from 'date-fns/format'
import Message from '../../common/Message'
import useTranslation from '../../util/useTranslation'
import RelayCorrectDistances from './RelayCorrectDistances'
import LegButtons from './LegButtons'

export default function RelayStatus({ race, relay, leg, children }) {
  const { t } = useTranslation()
  const { estimatePenaltySeconds, finished, penaltySeconds, shootingPenaltySeconds, started, startTime, teams } = relay
  if (!teams.length) {
    return <Message type="info">{t('relayWithoutTeams')}</Message>
  } else if (!startTime) {
    return <Message type="info">{t('relayWithoutStartTime')}</Message>
  }
  return (
    <>
      {!started && (
        <Message type="info">{t('relayStartTime', { time: format(new Date(startTime), 'dd.MM.yyyy HH:mm') })}</Message>
      )}
      {penaltySeconds && (
        <Message type="info">
          {t(`relayPenaltySeconds_${race.sportKey}`, { estimatePenaltySeconds, shootingPenaltySeconds })}
        </Message>
      )}
      <RelayCorrectDistances relay={relay} />
      {finished && <h3>{t('results')}</h3>}
      <LegButtons relay={relay} currentLeg={leg} />
      {children}
    </>
  )
}
