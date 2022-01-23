import React, { useCallback, useEffect } from 'react'
import useMenu, { pages } from '../../util/useMenu'
import Batches from './Batches'
import { buildQualificationRoundBatchesPath } from '../../util/routeUtil'

export default function QualificationRoundBatches() {
  const { setSelectedPage } = useMenu(pages.batches.qualificationRound)
  const buildApiPath = useCallback(raceId => {
    return `/api/v2/public/races/${raceId}/qualification_round_batches`
  }, [])
  const buildPdfPath = useCallback(raceId => `${buildQualificationRoundBatchesPath(raceId)}.pdf`, [])
  useEffect(() => setSelectedPage(pages.batches.qualificationRound), [setSelectedPage])
  return (
    <Batches
      buildApiPath={buildApiPath}
      buildPdfPath={buildPdfPath}
      hideAttribute="hideQualificationRoundBatches"
      titleKey="qualificationRoundBatchList"
      trackPlaceAttribute="qualificationRoundTrackPlace"
    />
  )
}
