import React from 'react'
import useTranslation from '../../util/useTranslation'
import BatchTime from './BatchTime'

export default function Batch({ race, batch, trackPlaceAttribute, seriesId }) {
  const { t } = useTranslation()
  const { competitors, number, track } = batch
  return (
    <div key={number} className="col-xs-12 col-sm-6 batch">
      <div className="card">
        <div className="card__number">{number}</div>
        <div className="card__middle">
          <div className="card__name">
            <BatchTime race={race} batch={batch} />
            {track && ` (${t('track')} ${track})`}
          </div>
          {competitors.filter(c => !seriesId || c.seriesId === seriesId).map(competitor => {
            const { id, firstName, lastName, club, series } = competitor
            return (
              <div key={id} className="card__middle-row">
                {competitor[trackPlaceAttribute]}. {lastName} {firstName}
                {competitor.number ? ` (${competitor.number})` : ''}, {club.name} ({series.name})
              </div>
            )
          })}
        </div>
      </div>
    </div>
  )
}
