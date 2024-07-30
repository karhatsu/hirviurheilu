import React, { useCallback, useEffect } from 'react'
import useMenu, { pages } from '../../util/useMenu'
import Heats from './Heats'
import { buildFinalRoundHeatsPath } from '../../util/routeUtil'

export default function FinalRoundHeats() {
  const { setSelectedPage } = useMenu(pages.heats.finalRound)
  const buildApiPath = useCallback(raceId => {
    return `/api/v2/public/races/${raceId}/final_round_heats`
  }, [])
  const buildPdfPath = useCallback(raceId => `${buildFinalRoundHeatsPath(raceId)}.pdf`, [])
  useEffect(() => setSelectedPage(pages.heats.finalRound), [setSelectedPage])
  return (
    <Heats
      buildApiPath={buildApiPath}
      buildPdfPath={buildPdfPath}
      hideAttribute="hideFinalRoundHeats"
      titleKey="finalRoundHeatList"
      trackPlaceAttribute="finalRoundTrackPlace"
    />
  )
}
