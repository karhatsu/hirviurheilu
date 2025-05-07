import { useCallback, useEffect } from 'react'
import useMenu, { pages } from '../../util/useMenu'
import Heats from './Heats'
import { buildQualificationRoundHeatsPath } from '../../util/routeUtil'

export default function QualificationRoundHeats() {
  const { setSelectedPage } = useMenu(pages.heats.qualificationRound)
  const buildApiPath = useCallback((raceId) => {
    return `/api/v2/public/races/${raceId}/qualification_round_heats`
  }, [])
  const buildPdfPath = useCallback((raceId) => `${buildQualificationRoundHeatsPath(raceId)}.pdf`, [])
  useEffect(() => setSelectedPage(pages.heats.qualificationRound), [setSelectedPage])
  return (
    <Heats
      buildApiPath={buildApiPath}
      buildPdfPath={buildPdfPath}
      hideAttribute="hideQualificationRoundHeats"
      titleKey="qualificationRoundHeatList"
      trackPlaceAttribute="qualificationRoundTrackPlace"
    />
  )
}
