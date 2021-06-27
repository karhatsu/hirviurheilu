import React from 'react'
import { timeFromSeconds } from '../../util/timeUtil'

export default function RelayTimeAdjustment({ adjustment, estimateAdjustment, shootingAdjustment }) {
  if (!adjustment && !estimateAdjustment && !shootingAdjustment) return ''
  const titles = []
  if (estimateAdjustment) titles.push(`Aika sisältää arviokorjausta ${timeFromSeconds(estimateAdjustment, true)}`)
  if (shootingAdjustment) titles.push(`Aika sisältää ammuntakorjausta ${timeFromSeconds(shootingAdjustment, true)}`)
  if (adjustment) titles.push(`Aika sisältää muuta korjausta ${timeFromSeconds(adjustment, true)}`)
  const title = titles.length ? `${titles.join('. ')}.` : ''
  return (
    <>
      {' '}
      <span className="adjustment" title={title}>
        ({timeFromSeconds(adjustment + estimateAdjustment + shootingAdjustment, true)})
      </span>
    </>
  )
}
