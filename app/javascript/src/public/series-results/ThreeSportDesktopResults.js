import React, { useCallback } from 'react'
import useTranslation from '../../util/useTranslation'
import Points from './Points'
import TimePoints from './TimePoints'
import EstimatePoints from './EstimatePoints'
import ShootingPoints from './ShootingPoints'
import NationalRecord from './NationalRecord'
import useCompetitorSorting from './useCompetitorSorting'
import { resolveClubTitle } from '../../util/clubUtil'
import { timeFromSeconds } from '../../util/timeUtil'
import DesktopResultsRows from './DesktopResultsRows'

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

  return (
    <div className="results--desktop">
      <table className="results-table">
        <thead>
          <tr>
            <th>&nbsp;</th>
            <th>{t('name')}</th>
            <th>{t('numberShort')}</th>
            <th id="table_club_title">{resolveClubTitle(t, clubLevel)}</th>
            {timePoints && <th className="center">{createTitle(`timeTitle_${sportKey}`, sortMethods.time)}</th>}
            <th className="center">{createTitle('estimating', sortMethods.estimates)}</th>
            <th className="center">{createTitle('shooting', sortMethods.shooting)}</th>
            <th className="total-points">{createTitle('points', sortMethods.points)}</th>
          </tr>
        </thead>
        <DesktopResultsRows competitors={competitors} sortMethod={sortMethod}>
          {competitor => {
            const { comparisonTimeInSeconds } = competitor
            return (
              <>
                {timePoints && (
                  <td title={`${t('comparisonTime')}: ${timeFromSeconds(comparisonTimeInSeconds)}`}>
                    <TimePoints competitor={competitor} series={series} />
                  </td>
                )}
                <td><EstimatePoints competitor={competitor} series={series} race={race} /></td>
                <td><ShootingPoints competitor={competitor} /></td>
                <td className="center total-points">
                  <Points competitor={competitor}/>
                  <NationalRecord race={race} series={series} competitor={competitor} />
                </td>
              </>
            )
          }}
        </DesktopResultsRows>
      </table>
    </div>
  )
}
