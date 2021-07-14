import React from 'react'
import useTranslation from '../../util/useTranslation'
import Message from '../../common/Message'

export default function ThreeSportRaceInfo({ race, series }) {
  const { t } = useTranslation()
  const { showCorrectDistances, sportKey } = race
  const { active, ageGroups, pointsMethod, shorterTrip } = series
  const ageGroupsShorterTrip = ageGroups.filter(ag => ag.shorterTrip).map(ag => ag.name)
  const ageGroupsText = () => {
    const key = `ageGroup${ageGroupsShorterTrip.length > 1 ? 's' : ''}ShorterTrip`
    return t(key, { ageGroups: ageGroupsShorterTrip.join(', ') })
  }
  return (
    <>
      {active && (
        <Message type="info">
          {t(showCorrectDistances ? 'raceUnfinished' : 'raceUnfinishedDistancesLater')}
        </Message>
      )}
      {pointsMethod !== 0 && (
        <Message type="info">{t(`seriesPointsMethod${pointsMethod}_${sportKey}`)}</Message>
      )}
      {shorterTrip && <Message type="info">{t('seriesShorterTrip')}</Message>}
      {ageGroupsShorterTrip.length > 0 && <Message type="info">{ageGroupsText()}</Message>}
    </>
  )
}
