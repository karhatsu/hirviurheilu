import React from 'react'
import Message from '../../common/Message'
import useTranslation from '../../util/useTranslation'

export default function RelayCorrectDistances({ relay }) {
  const { t } = useTranslation()
  const { correctDistances, finished, started } = relay
  if (started && !finished) {
    return <Message type="info">{t('raceUnfinishedDistancesLater')}</Message>
  } else if (!finished) {
    return null
  }
  return (
    <>
      <h3>{t('correctDistances')}</h3>
      <div className="row">
        {correctDistances.map(cd => {
          return (
            <div key={cd.leg} className="col-xs-4 col-sm-3 col-md-2">
              <div className="card">
                <div className="card__middle">
                  <div className="card__name">{t('leg')} {cd.leg}</div>
                  <div className="card__middle-row">{cd.distance} m</div>
                </div>
              </div>
            </div>
          )
        })}
      </div>
    </>
  )
}
