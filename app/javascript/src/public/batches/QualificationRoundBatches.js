import React, { useCallback, useEffect } from 'react'
import { pages } from '../menu/DesktopSecondLevelMenu'
import Batches from './Batches'
import { buildQualificationRoundBatchesPath } from '../../util/routeUtil'

export default function QualificationRoundBatches({ setSelectedPage }) {
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
