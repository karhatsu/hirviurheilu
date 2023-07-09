import React from 'react'
import { Link } from 'react-router-dom'
import classnames from 'classnames-minimal'
import { buildTeamCompetitionsPath } from '../../util/routeUtil'

export default function CupTeamCompetitionPoints({ raceId, team, cupTeam }) {
  if (!team) return '-'
  const { minPointsToEmphasize } = cupTeam
  const { totalScore, teamCompetitionId } = team
  const className = classnames({ 'cup-points__emphasize': minPointsToEmphasize && totalScore >= minPointsToEmphasize })
  return (
    <Link to={buildTeamCompetitionsPath(raceId, teamCompetitionId)} className={className}>
      {totalScore}
    </Link>
  )
}
