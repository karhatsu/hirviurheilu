import React, { useCallback, useEffect } from 'react'
import useMenu, { pages } from '../../util/useMenu'
import Batches from './Batches'
import { buildFinalRoundBatchesPath } from '../../util/routeUtil'

export default function FinalRoundBatches() {
  const { setSelectedPage } = useMenu(pages.batches.finalRound)
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
