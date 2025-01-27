import React from 'react'
import { Link } from 'react-router'
import classnames from 'classnames-minimal'
import { buildTeamCompetitionsPath } from '../../util/routeUtil'

export default function CupTeamCompetitionPoints({ raceId, team, cupTeam }) {
  if (!team) return '-'
  const { minScoreToEmphasize } = cupTeam
  const { totalScore, teamCompetitionId } = team
  const className = classnames({ 'cup-points__emphasize': minScoreToEmphasize && totalScore >= minScoreToEmphasize })
  return (
    <Link to={buildTeamCompetitionsPath(raceId, teamCompetitionId)} className={className}>
      {totalScore}
    </Link>
  )
}
