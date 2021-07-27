import React from 'react'
import { useLocation } from 'react-router-dom'
import { useResultRotation } from './result-rotation/useResultRotation'

const isValidPath = path => {
  return path === '/' || path.match(/^\/races\//) || path.match(/^\/announcements\//) || path.match(/^\/cups\//)
}

export default function FacebookShare() {
  const location = useLocation()
  const appElement = document.getElementById('react-app')
  const { started: resultRotationRunning } = useResultRotation()
  if (resultRotationRunning) return null
  if (!appElement) return null
  const environment = appElement.getAttribute('data-env')
  if (!['production', 'development'].includes(environment)) return null
  const { pathname } = location
  if (!isValidPath(pathname)) return null
  const url = `https://www.hirviurheilu.com${pathname}`
  return (
    <div className="fb-share-container">
      <div className="fb-share-button" data-href={url} datatype="button_count" />
    </div>
  )
}
