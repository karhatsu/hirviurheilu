import React from 'react'
import useTranslation from '../../util/useTranslation'
import ShootingResult from './ShootingResult'
import { resolveClubTitle } from '../../util/clubUtil'
import NationalRecord from './NationalRecord'

export default function EuropeanDesktopResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors } = series
  const extraShots = !!competitors.find(c => c.nordicExtraScore)
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
            <th>{t('european_trap')}</th>
            <th>{t('european_compak')}</th>
            <th>{t('european_rifle1')}</th>
            <th>{t('european_rifle2')}</th>
            <th>{t('european_rifle3')}</th>
            <th>{t('european_rifle4')}</th>
            <th>{t('result')}</th>
            {extraShots && <th>{t('extraRound')}</th>}
          </tr>
        </thead>
        <tbody>
          {competitors.map((competitor, i) => {
            const {
              club,
              europeanExtraScore,
              europeanScore,
              europeanRifle1Score,
              europeanRifle1Shots,
              europeanRifle2Score,
              europeanRifle2Shots,
              europeanRifle3Score,
              europeanRifle3Shots,
              europeanRifle4Score,
              europeanRifle4Shots,
              europeanCompakScore,
              europeanCompakShots,
              europeanTrapScore,
              europeanTrapShots,
              firstName,
              id,
              lastName,
              position,
              noResultReason,
              number,
            } = competitor
            const orderNo = position === prevCompetitorPosition ? '' : `${position}.`
            prevCompetitorPosition = position
            const result = noResultReason ? t(`competitor_${noResultReason}`) : europeanScore
            return (
              <tr key={id} className={i % 2 === 0 ? 'odd' : ''}>
                <td>{orderNo}</td>
                <td>{lastName} {firstName}</td>
                <td>{number}</td>
                <td>{club.name}</td>
                <td><ShootingResult score={europeanTrapScore} shots={europeanTrapShots} /></td>
                <td><ShootingResult score={europeanCompakScore} shots={europeanCompakShots} /></td>
                <td><ShootingResult score={europeanRifle1Score} shots={europeanRifle1Shots} /></td>
                <td><ShootingResult score={europeanRifle2Score} shots={europeanRifle2Shots} /></td>
                <td><ShootingResult score={europeanRifle3Score} shots={europeanRifle3Shots} /></td>
                <td><ShootingResult score={europeanRifle4Score} shots={europeanRifle4Shots} /></td>
                <td className="center total-points">
                  {result || '-'}
                  <NationalRecord race={race} series={series} competitor={competitor} />
                </td>
                {extraShots && <td>{europeanExtraScore}</td>}
              </tr>
            )
          })}
        </tbody>
      </table>
    </div>
  )
}
