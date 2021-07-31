import React from 'react'

export default function FacebookLikeBox() {
  const appElement = document.getElementById('react-app')
  if (!appElement) return null
  const environment = appElement.getAttribute('data-env')
  if (!['production', 'development'].includes(environment)) return null
  return (
    <div className="fb-like-box-container">
      <div
        className="fb-like-box"
        data-href="http://www.facebook.com/Hirviurheilu"
        data-width={360}
        data-show-faces={false}
        data-stream={false}
        data-header={true}
      />
    </div>
  )
}
