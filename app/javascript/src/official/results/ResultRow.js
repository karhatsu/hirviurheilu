import Spinner from '../../common/Spinner'
import Message from '../../common/Message'
import useTranslation from '../../util/useTranslation'

const ResultRow = ({ children, competitor, errors, result, saved, saving, seriesName, withTrackPlace }) => {
  const { t } = useTranslation()
  const { firstName, lastName, qualificationRoundTrackPlace, noResultReason, number } = competitor
  const seriesNameText = seriesName ? ` (${seriesName})` : ''
  const trackPlaceText =
    withTrackPlace && qualificationRoundTrackPlace
      ? `, ${t('trackPlace').toLocaleLowerCase()}: ${qualificationRoundTrackPlace}`
      : ''
  return (
    <div className="card">
      <div className="card__number">#{number}</div>
      <div className="card__middle">
        <div className="card__name">
          <span>
            {lastName} {firstName}
            {seriesNameText}
            {trackPlaceText}
          </span>
          {saving && <Spinner />}
          {errors && (
            <Message inline={true} type="error">
              {errors.join('. ')}.
            </Message>
          )}
          {saved && (
            <Message inline={true} type="success">
              {t('saved')}
            </Message>
          )}
        </div>
        {!noResultReason && <div className="card__middle-row">{children}</div>}
      </div>
      <div className="card__main-value">
        {noResultReason && <div>{noResultReason}</div>}
        {!noResultReason && <div>{result}</div>}
      </div>
    </div>
  )
}

export default ResultRow
