import React from 'react'
import useTranslation from '../../util/useTranslation'
import { buildFinalRoundHeatsPath, buildQualificationRoundHeatsPath } from '../../util/routeUtil'
import Button from '../../common/Button'

export default function RaceHeats({ race }) {
  const { t } = useTranslation()
  const { qualificationRoundHeats, finalRoundHeats, sport } = race
  if (!qualificationRoundHeats.length && !finalRoundHeats.length) return null
  const qrText = sport.oneHeatList ? t('heatList') : t('qualificationRoundHeatList')
  return (
    <>
      <h2>{t('heatList')}</h2>
      <div className="buttons" id="heat-links">
        {qualificationRoundHeats.length > 0 && (
          <Button to={buildQualificationRoundHeatsPath(race.id)} type="primary">{qrText}</Button>
        )}
        {finalRoundHeats.length > 0 && (
          <Button to={buildFinalRoundHeatsPath(race.id)} type="primary">{t('finalRoundHeatList')}</Button>
        )}
      </div>
    </>
  )
}
