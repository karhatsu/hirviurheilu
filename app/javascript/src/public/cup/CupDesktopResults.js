import React from 'react'
import useTranslation from '../../util/useTranslation'
import CupPoints from './CupPoints'

export default function CupDesktopResults({ cup, cupSeries }) {
  const { t } = useTranslation()
  const { races } = cup
  const { name, seriesNames, cupCompetitors } = cupSeries
  const showSeries = !!(seriesNames && seriesNames !== name)
  return (
    <div className="cup_results results--desktop">
      <table className="results-table">
        <thead>
          <tr>
            <th />
            <th>{t('competitor')}</th>
            {showSeries && <th>{t('series')}</th>}
            {races.map(race => <th key={race.id}>{race.name}</th>)}
            <th>{t('totalPoints')}</th>
          </tr>
        </thead>
        <tbody>
        {cupCompetitors.map((cupCompetitor, i) => {
          const { firstName, lastName, seriesNames, points, partialPoints } = cupCompetitor
          const name = `${lastName} ${firstName}`
          return (
            <tr key={name} id={`comp_${i + 1}`} className={i % 2 === 0 ? 'odd' : ''}>
              <td>{i + 1}.</td>
              <td>{name}</td>
              {showSeries && <td>{seriesNames}</td>}
              {cupCompetitor.races.map(race => {
                const { competitor, id } = race
                return (
                  <td key={id} className="center">
                    <CupPoints raceId={id} competitor={competitor} cupCompetitor={cupCompetitor} />
                  </td>
                )
              })}
              <td className="center total-points">{points || (partialPoints && `(${partialPoints})`)}</td>
            </tr>
          )
        })}
        </tbody>
      </table>
    </div>
  )
}
