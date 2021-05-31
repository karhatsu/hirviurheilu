import React from 'react'
import useTranslation from '../../util/useTranslation'

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
        <div className="message message--info">
          {t(showCorrectDistances ? 'raceUnfinished' : 'raceUnfinishedDistancesLater')}
        </div>
      )}
      {pointsMethod !== 0 && (
        <div className="message message--info">{t(`seriesPointsMethod${pointsMethod}_${sportKey}`)}</div>
      )}
      {shorterTrip && <div className="message message--info">{t('seriesShorterTrip')}</div>}
      {ageGroupsShorterTrip.length > 0 && <div className="message message--info">{ageGroupsText()}</div>}
    </>
  )
}
