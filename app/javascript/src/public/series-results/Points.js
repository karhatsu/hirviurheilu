import React from 'react'
import useTranslation from '../../util/useTranslation'

export default function Points({ competitor }) {
  const { t } = useTranslation()
  const { finished, hasCorrectEstimates, noResultReason, points } = competitor
  if (noResultReason) {
    return <span className="explanation" title={t(`competitor_${noResultReason}`)}>{noResultReason}</span>
  } else if (!points) {
    return '-'
  } else {
    return finished && hasCorrectEstimates ? points : `(${points})`
  }
}
