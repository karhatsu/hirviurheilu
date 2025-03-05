import { Link } from 'react-router'
import classnames from 'classnames-minimal'
import NoResultReason from '../NoResultReason'
import { buildSeriesResultsPath } from '../../util/routeUtil'

export default function CupRacePoints({ raceId, competitor, cupCompetitor }) {
  if (!competitor) return '-'
  const { minScoreToEmphasize } = cupCompetitor
  const { noResultReason, score, seriesId } = competitor
  if (noResultReason) return <NoResultReason noResultReason={noResultReason} type="competitor" />
  const className = classnames({ 'cup-points__emphasize': minScoreToEmphasize && score >= minScoreToEmphasize })
  return (
    <Link to={buildSeriesResultsPath(raceId, seriesId)} className={className}>
      {score}
    </Link>
  )
}
