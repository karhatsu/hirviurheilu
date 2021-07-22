import React from 'react'
import { Link } from 'react-router-dom'
import classnames from 'classnames-minimal'
import NoResultReason from '../NoResultReason'
import { buildSeriesResultsPath } from '../../util/routeUtil'

export default function CupPoints({ raceId, competitor, cupCompetitor }) {
  if (!competitor) return '-'
  const { minPointsToEmphasize } = cupCompetitor
  const { noResultReason, points, seriesId } = competitor
  if (noResultReason) return <NoResultReason noResultReason={noResultReason} type="competitor" />
  const className = classnames({ 'cup-points__emphasize': minPointsToEmphasize && points >= minPointsToEmphasize })
  return (
    <Link to={buildSeriesResultsPath(raceId, seriesId)} className={className}>
      {points}
    </Link>
  )
}
