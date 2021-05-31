import React from 'react'

export default function MobileSubResult({ children, type }) {
  return <span className={`card__sub-result card__sub-result--${type}`}>{children}</span>
}
