import React from 'react'
import useAppData from '../../util/useAppData'

export default function FacebookLikeBox() {
  const { environment } = useAppData()
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
