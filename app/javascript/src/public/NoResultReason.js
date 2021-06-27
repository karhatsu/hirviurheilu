import React from 'react'
import useTranslation from '../util/useTranslation'

export default function NoResultReason({ noResultReason, type }) {
  const { t } = useTranslation()
  return <span className="explanation" title={t(`${type}_${noResultReason}`)}>{noResultReason}</span>
}
