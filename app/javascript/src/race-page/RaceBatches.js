import React from 'react'
import useTranslation from '../util/useTranslation'
import { buildFinalRoundBatchesLink, buildQualificationRoundBatchesLink } from '../util/routeUtil'

export default function RaceBatches({ race }) {
  const { t } = useTranslation()
  const { qualificationRoundBatches, finalRoundBatches, sport } = race
  if (!qualificationRoundBatches.length && !finalRoundBatches.length) return null
  const qrText = sport.oneBatchList ? t('batchLists') : t('qualificationRoundBatchLists')
  return (
    <>
      <h2>{t('batchLists')}</h2>
      <div className="buttons" id="batch-links">
        {qualificationRoundBatches.length > 0 && (
          <a href={buildQualificationRoundBatchesLink(race.id)} className="button button--primary">{qrText}</a>
        )}
        {finalRoundBatches.length > 0 && (
          <a href={buildFinalRoundBatchesLink(race.id)} className="button button--primary">{t('finalRoundBatchLists')}</a>
        )}
      </div>
    </>
  )
}
