import React from 'react'
import useTranslation from '../../util/useTranslation'
import { resolveClubTitle } from '../../util/clubUtil'
import NationalRecord from './NationalRecord'
import ShootingResult from './ShootingResult'
import QualificationRoundDesktopShootingResult from './QualificationRoundDesktopShootingResult'

export default function ShootingDesktopResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors } = series
  const showExtraShots = !!competitors.find(c => c.extraShots)
  let prevCompetitorPosition = 0
  return (
    <div className="results--desktop">
      <table className="results-table">
        <thead>
          <tr>
            <th />
            <th>{t('name')}</th>
            <th>{t('numberShort')}</th>
            <th>{resolveClubTitle(t, race.clubLevel)}</th>
            <th>{t('qualificationRound')}</th>
            <th>{t('finalRound')}</th>
            <th>{t('result')}</th>
            {showExtraShots && <th>{t('extraRound')}</th>}
          </tr>
        </thead>
        <tbody>
          {competitors.map((competitor, i) => {
            const {
              club,
              extraShots,
              finalRoundScore,
              finalRoundShots,
              firstName,
              id,
              lastName,
              number,
              noResultReason,
              position,
              shootingScore,
            } = competitor
            const orderNo = position === prevCompetitorPosition ? '' : `${position}.`
            prevCompetitorPosition = position
            const result = noResultReason || shootingScore
            return (
              <tr key={id} className={i % 2 === 0 ? 'odd' : ''}>
                <td>{orderNo}</td>
                <td>{lastName} {firstName}</td>
                <td>{number}</td>
                <td>{club.name}</td>
                <td><QualificationRoundDesktopShootingResult competitor={competitor} /></td>
                <td><ShootingResult score={finalRoundScore} shots={finalRoundShots && finalRoundShots[0]} /></td>
                <td className="center total-points">
                  {result}
                  <NationalRecord race={race} series={series} competitor={competitor} />
                </td>
                {showExtraShots && <td>{extraShots ? extraShots.join(', ') : ''}</td>}
              </tr>
            )
          })}
        </tbody>
      </table>
    </div>
  )
}
