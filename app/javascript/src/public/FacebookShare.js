import { useLocation } from 'react-router'
import { useResultRotation } from './result-rotation/useResultRotation'
import useAppData from '../util/useAppData'

const isValidPath = (path) => {
  return path === '/' || path.match(/^\/races\//) || path.match(/^\/announcements\//) || path.match(/^\/cups\//)
}

export default function FacebookShare() {
  const location = useLocation()
  const { environment } = useAppData()
  const { started: resultRotationRunning } = useResultRotation()
  if (resultRotationRunning) return null
  if (!['production', 'development'].includes(environment)) return null
  const { pathname } = location
  if (!isValidPath(pathname)) return null
  const url = `https://www.hirviurheilu.com${pathname}`
  return (
    <div className="fb-share-container">
      <div className="fb-share-button" data-href={url} data-layout="button_count" />
    </div>
  )
}
