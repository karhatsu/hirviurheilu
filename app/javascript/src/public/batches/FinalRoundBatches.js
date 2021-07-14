import React, { useCallback, useEffect } from 'react'
import { pages } from '../menu/DesktopSecondLevelMenu'
import Batches from './Batches'
import { buildFinalRoundBatchesPath } from '../../util/routeUtil'

export default function FinalRoundBatches({ setSelectedPage }) {
  const buildApiPath = useCallback(raceId => {
    return `/api/v2/public/races/${raceId}/final_round_batches`
  }, [])
  const buildPdfPath = useCallback(raceId => `${buildFinalRoundBatchesPath(raceId)}.pdf`, [])
  useEffect(() => setSelectedPage(pages.batches.finalRound), [setSelectedPage])
  return (
    <Batches
      buildApiPath={buildApiPath}
      buildPdfPath={buildPdfPath}
      hideAttribute="hideFinalRoundBatches"
      titleKey="finalRoundBatchList"
      trackPlaceAttribute="finalRoundTrackPlace"
    />
  )
}
