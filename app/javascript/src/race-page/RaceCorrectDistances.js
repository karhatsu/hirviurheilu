import React from 'react'
import useTranslation from '../util/useTranslation'

const buildRange = ce => {
  if (ce.minNumber === ce.maxNumber) return ce.minNumber
  if (!ce.maxNumber) return `${ce.minNumber}-`
  return `${ce.minNumber}-${ce.maxNumber}`
}

export default function RaceCorrectDistances({ race }) {
  const { t } = useTranslation()
  if (!race.finished || race.sport.shooting) return null
  return (
    <>
      <h3>{t('correctDistances')}</h3>
      <div className="row">
        {race.correctEstimates.map(ce => {
          return (
            <div className="col-xs-6 col-sm-4 col-md-3" key={ce.minNumber}>
              <div className="card">
                <div className="card__middle">
                  <div className="card__name">{buildRange(ce)}</div>
                  <div className="card__middle-row">{ce.distances.map(d => `${d} m`).join(', ')}</div>
                </div>
              </div>
            </div>
          )
        })}
      </div>
    </>
  )
}
