import React from 'react'
import useTranslation from '../../util/useTranslation'

export default function MobileSubResult({ children, titleKey, type }) {
  const { t } = useTranslation()
  return (
    <span className={`card__sub-result card__sub-result--${type}`}>
      {titleKey ? `${t(titleKey)}: ` : ''}{children}
    </span>
  )
}
