import React from 'react'

export default function FacebookShare() {
  const appElement = document.getElementById('react-app')
  if (!appElement) return null
  const facebookUrl = appElement.getAttribute('facebook_url')
  if (!facebookUrl) return null
  return (
    <div className="fb-share-container">
      <div className="fb-share-button" data-href={facebookUrl} datatype="button_count" />
    </div>
  )
}
