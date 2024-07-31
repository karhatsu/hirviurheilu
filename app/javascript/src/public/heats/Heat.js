import React from 'react'
import useTranslation from '../../util/useTranslation'
import HeatTime from './HeatTime'

export default function Heat({ race, heat, trackPlaceAttribute, seriesId }) {
  const { t } = useTranslation()
  const { competitors, number, track } = heat
  return (
    <div key={number} className="col-xs-12 col-sm-6 heat">
      <div className="card">
        <div className="card__number">{number}</div>
        <div className="card__middle">
          <div className="card__name">
            <HeatTime race={race} heat={heat} />
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
