import { nationalRecordUrl } from '../../util/sportUtil'

export default function NationalRecord({ race, series, competitor }) {
  const { totalScore, position } = competitor
  const { nationalRecord } = series
  if (!totalScore || !nationalRecord || totalScore < nationalRecord || position > 1) return null
  const text = `${totalScore === nationalRecord ? '=' : ''}SE${race.finished || series.finished ? '' : '?'}`
  return (
    <span className="explanation">
      {' '}
      <a href={nationalRecordUrl} target="_blank" rel="noreferrer">
        {text}
      </a>
    </span>
  )
}
