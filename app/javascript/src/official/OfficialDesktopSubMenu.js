import { Route, Routes } from 'react-router'
import SeriesDesktopSubMenu from '../public/menu/SeriesDesktopSubMenu'
import { buildOfficialSeriesEstimatesPath, buildOfficialSeriesTimesPath } from '../util/routeUtil'
import { useRace } from '../util/useRace'
import { usePathParams } from '../public/PathParamsProvider'

export default function OfficialDesktopSubMenu() {
  const { seriesId } = usePathParams()
  const { race } = useRace()
  return (
    <Routes>
      <Route path="races/:raceId" element={null}>
        <Route
          path="series/:seriesId/estimates"
          element={<SeriesDesktopSubMenu
            race={race}
            currentSeriesId={seriesId}
            buildSeriesPath={buildOfficialSeriesEstimatesPath}
          />}
        />
        <Route
          path="series/:seriesId/times"
          element={<SeriesDesktopSubMenu
            race={race}
            currentSeriesId={seriesId}
            buildSeriesPath={buildOfficialSeriesTimesPath}
          />}
        />
      </Route>
    </Routes>
  )
}
