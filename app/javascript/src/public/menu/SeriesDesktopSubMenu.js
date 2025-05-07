import { useParams } from 'react-router'
import DesktopMenuItem from './DesktopMenuItem'

export default function SeriesDesktopSubMenu({ race, buildSeriesPath, currentSeriesId }) {
  const { subSport } = useParams()
  if (!race || race.series.length < 2) return null
  return (
    <div className="menu menu--sub menu--sub-2">
      {race.series.map((series) => {
        const { id, name } = series
        const selected = parseInt(currentSeriesId) === id
        const path = buildSeriesPath(race.id, id, subSport)
        return <DesktopMenuItem key={id} path={path} text={name} selected={selected} reactLink={true} />
      })}
    </div>
  )
}
