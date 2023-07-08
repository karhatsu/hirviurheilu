import React from 'react'
import { Link } from 'react-router-dom'
import classnames from 'classnames-minimal'
import NoResultReason from '../NoResultReason'
import { buildSeriesResultsPath } from '../../util/routeUtil'

export default function CupPoints({ raceId, competitor, cupCompetitor }) {
  if (!competitor) return '-'
  const { minPointsToEmphasize } = cupCompetitor
  const { noResultReason, points, totalScore, seriesId } = competitor
  if (noResultReason) return <NoResultReason noResultReason={noResultReason} type="competitor" />
  const score = points || totalScore // points for individuals, totalScore for teams
  const className = classnames({ 'cup-points__emphasize': minPointsToEmphasize && score >= minPointsToEmphasize })
  return (
    <Link to={buildSeriesResultsPath(raceId, seriesId)} className={className}>
      {score}
    </Link>
  )
}
