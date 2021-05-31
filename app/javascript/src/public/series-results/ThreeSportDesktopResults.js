import React, { useCallback } from 'react'
import useTranslation from '../../util/useTranslation'
import { raceEnums } from '../../util/enums'
import UnofficialLabel from './UnofficialLabel'
import Points from './Points'
import TimePoints from './TimePoints'
import EstimatePoints from './EstimatePoints'
import ShootingPoints from './ShootingPoints'
import NationalRecord from './NationalRecord'
import useCompetitorSorting from './useCompetitorSorting'

export default function ThreeSportDesktopResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors, sortMethod, sortMethods, sort } = useCompetitorSorting(series)

  const { clubLevel, sportKey } = race
  const { timePoints } = series

  const createTitle = useCallback((textKey, titleSortMethod) => {
    if (sortMethod === titleSortMethod) return t(textKey)
    const onClick = e => {
      e.preventDefault()
      sort(titleSortMethod)
    }
    return <a href="#" onClick={onClick}>{t(textKey)}</a>
  }, [sortMethod, sort, t])

  let prevCompetitorPosition = 0
  return (
    <div className="results--desktop">
      <table className="results-table">
        <thead>
          <tr>
            <th>&nbsp;</th>
            <th>{t('name')}</th>
            <th>{t('numberShort')}</th>
            <th id="table_club_title">{t(clubLevel === raceEnums.clubLevel.club ? 'club' : 'district')}</th>
            {timePoints && <th className="center">{createTitle(`timeTitle_${sportKey}`, sortMethods.time)}</th>}
            <th className="center">{createTitle('estimating', sortMethods.estimates)}</th>
            <th className="center">{createTitle('shooting', sortMethods.shooting)}</th>
            <th className="total-points">{createTitle('points', sortMethods.points)}</th>
          </tr>
        </thead>
        <tbody>
          {competitors.map((competitor, i) => {
            const { ageGroup, club, firstName, id, lastName, number, position, unofficial } = competitor
            let name = `${lastName} ${firstName}`
            if (ageGroup) {
              name = `${name} (${ageGroup.name})`
            }
            const orderNo = sortMethod !== sortMethods.points
              ? `${i + 1}.`
              : position === prevCompetitorPosition ? '' : `${position}.`
            prevCompetitorPosition = position
            return (
              <tr key={id} className={i % 2 === 0 ? 'odd' : ''} id={`comp_${i + 1}`}>
                <td>{orderNo}</td>
                <td>{name} <UnofficialLabel unofficial={unofficial} /></td>
                <td>{number}</td>
                <td>{club.name}</td>
                {timePoints && <td><TimePoints competitor={competitor} series={series} /></td>}
                <td><EstimatePoints competitor={competitor} series={series} race={race} /></td>
                <td><ShootingPoints competitor={competitor} /></td>
                <td className="center total-points">
                  <Points competitor={competitor}/>
                  {i === 0 && <NationalRecord race={race} series={series} competitor={competitor} />}
                </td>
              </tr>
            )
          })}
        </tbody>
      </table>
    </div>
  )
}
