import React from 'react'
import useTranslation from '../../util/useTranslation'
import { buildFinalRoundBatchesPath, buildQualificationRoundBatchesPath } from '../../util/routeUtil'
import Button from '../../common/Button'

export default function RaceBatches({ race }) {
  const { t } = useTranslation()
  const { qualificationRoundBatches, finalRoundBatches, sport } = race
  if (!qualificationRoundBatches.length && !finalRoundBatches.length) return null
  const qrText = sport.oneBatchList ? t('batchList') : t('qualificationRoundBatchList')
  return (
    <>
      <h2>{t('batchList')}</h2>
      <div className="buttons" id="batch-links">
        {qualificationRoundBatches.length > 0 && (
          <Button to={buildQualificationRoundBatchesPath(race.id)} type="primary">{qrText}</Button>
        )}
        {finalRoundBatches.length > 0 && (
          <Button to={buildFinalRoundBatchesPath(race.id)} type="primary">{t('finalRoundBatchList')}</Button>
        )}
      </div>
    </>
  )
}
