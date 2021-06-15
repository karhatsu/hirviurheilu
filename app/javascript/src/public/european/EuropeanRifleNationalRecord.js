import React from 'react'
import NationalRecord from '../series-results/NationalRecord'

export default function EuropeanRifleNationalRecord({ race, series, competitor }) {
  const rifleSeries = { ...series, nationalRecord: series.rifleNationalRecord }
  const rifleCompetitor = { ...competitor, points: competitor.europeanRifleScore }
  return <NationalRecord race={race} series={rifleSeries} competitor={rifleCompetitor} />
}
