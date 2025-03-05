import NationalRecord from './NationalRecord'
import useTranslation from '../../util/useTranslation'
import ShootingRaceMobileShootingResult from './ShootingRaceMobileShootingResult'
import TotalScore from './TotalScore'
import MobileResultCards from './MobileResultCards'
import ShootingResult from './ShootingResult'

export default function ShootingMobileResults({ race, series }) {
  const { t } = useTranslation()
  const { competitors } = series
  return (
    <MobileResultCards competitors={competitors}>
      {competitor => {
        const {
          club,
          extraScore,
          extraShots,
          firstName,
          lastName,
          noResultReason,
          totalScore,
        } = competitor
        return (
          <>
            <div className="card__middle">
              <div className="card__name">{lastName} {firstName}</div>
              <div className="card__middle-row">{club.name}</div>
              <ShootingRaceMobileShootingResult competitor={competitor} />
              {extraShots && (
                <div className="card__middle-row">
                  {t('extraRound')}: <ShootingResult score={extraScore} shots={extraShots} />
                </div>
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
