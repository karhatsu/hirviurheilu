import React from 'react'
import useTranslation from '../../util/useTranslation'

export default function TotalScore({ noResultReason, totalScore }) {
  const { t } = useTranslation()
  if (noResultReason) {
    return <span className="explanation" title={t(`competitor_${noResultReason}`)}>{noResultReason}</span>
  }
  return totalScore
}
