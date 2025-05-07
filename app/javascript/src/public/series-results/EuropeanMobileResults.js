import useTranslation from '../../util/useTranslation'
import MobileSubResult from './MobileSubResult'
import ShootingResult from './ShootingResult'
import NationalRecord from './NationalRecord'
import TotalScore from './TotalScore'
import MobileResultCards from './MobileResultCards'

export default function EuropeanMobileResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors } = series
  return (
    <MobileResultCards competitors={competitors}>
      {(competitor) => {
        const {
          club,
          europeanExtraScore,
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
          europeanRifle1Score2,
          europeanRifle1Shots2,
          europeanRifle2Score2,
          europeanRifle2Shots2,
          europeanRifle3Score2,
          europeanRifle3Shots2,
          europeanRifle4Score2,
          europeanRifle4Shots2,
          europeanCompakScore2,
          europeanCompakShots2,
          europeanTrapScore2,
          europeanTrapShots2,
          firstName,
          lastName,
          noResultReason,
          shootingRulesPenalty,
          totalScore,
        } = competitor
        return (
          <>
            <div className="card__middle">
              <div className="card__name">
                {lastName} {firstName}
              </div>
              <div className="card__middle-row">{club.name}</div>
              {noResultReason && <div className="card__middle-row">{t(`competitor_${noResultReason}`)}</div>}
              {!noResultReason && (
                <>
                  {europeanExtraScore && (
                    <div className="card__middle-row">
                      {t('extraRound')}: {europeanExtraScore}
                    </div>
                  )}
                  <div className="card__middle-row">
                    <MobileSubResult type="shoot" titleKey="european_trap">
                      <ShootingResult
                        score={europeanTrapScore}
                        shots={europeanTrapShots}
                        score2={europeanTrapScore2}
                        shots2={europeanTrapShots2}
                      />
                    </MobileSubResult>
                    <MobileSubResult type="shoot" titleKey="european_compak">
                      <ShootingResult
                        score={europeanCompakScore}
                        shots={europeanCompakShots}
                        score2={europeanCompakScore2}
                        shots2={europeanCompakShots2}
                      />
                    </MobileSubResult>
                    <MobileSubResult type="shoot" titleKey="european_rifle1">
                      <ShootingResult
                        score={europeanRifle1Score}
                        shots={europeanRifle1Shots}
                        score2={europeanRifle1Score2}
                        shots2={europeanRifle1Shots2}
                      />
                    </MobileSubResult>
                    <MobileSubResult type="shoot" titleKey="european_rifle2">
                      <ShootingResult
                        score={europeanRifle2Score}
                        shots={europeanRifle2Shots}
                        score2={europeanRifle2Score2}
                        shots2={europeanRifle2Shots2}
                      />
                    </MobileSubResult>
                    <MobileSubResult type="shoot" titleKey="european_rifle3">
                      <ShootingResult
                        score={europeanRifle3Score}
                        shots={europeanRifle3Shots}
                        score2={europeanRifle3Score2}
                        shots2={europeanRifle3Shots2}
                      />
                    </MobileSubResult>
                    <MobileSubResult type="shoot" titleKey="european_rifle4">
                      <ShootingResult
                        score={europeanRifle4Score}
                        shots={europeanRifle4Shots}
                        score2={europeanRifle4Score2}
                        shots2={europeanRifle4Shots2}
                      />
                    </MobileSubResult>
                  </div>
                  {shootingRulesPenalty && (
                    <div className="card__middle-row">
                      {t('shootingRulesPenalty')}: -{shootingRulesPenalty}
                    </div>
                  )}
                </>
              )}
            </div>
            <div className="card__main-value">
              <TotalScore noResultReason={noResultReason} totalScore={totalScore} />
              <NationalRecord race={race} series={series} competitor={competitor} />
            </div>
          </>
        )
      }}
    </MobileResultCards>
  )
}
