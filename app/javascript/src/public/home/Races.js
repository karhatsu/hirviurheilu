import { useMemo, useState } from 'react'
import { Link } from 'react-router'
import useTranslation from '../../util/useTranslation'
import { buildRacePath } from '../../util/routeUtil'
import DateInterval from '../../util/DateInterval'
import Button from '../../common/Button'

export default function Races({ races, titleKey, icon, sectionId, limit, children }) {
  const { t } = useTranslation()
  const [showAll, setShowAll] = useState(!limit)

  const visibleRaces = useMemo(() => {
    if (showAll || races.length <= 12) return races
    return races.slice(0, 8)
  }, [showAll, races])

  if (!races.length) return null

  return (
    <>
      <h2>
        <i className="material-icons-outlined md-18">{icon}</i>
        {t(titleKey)}
      </h2>
      <div id={sectionId} className="row">
        {visibleRaces.map((race) => {
          const { cancelled, id, name, startDate, endDate, location, sportKey } = race
          return (
            <div key={id} className="col-xs-12 col-sm-6 col-md-4">
              <Link className="card" to={buildRacePath(id)}>
                <div className="card__middle">
                  <div className="card__name">
                    {name}
                    {cancelled && <div className="badge badge--cancelled">{t('cancelled')}</div>}
                  </div>
                  <div className="card__middle-row">
                    <DateInterval startDate={startDate} endDate={endDate} />, {location}
                  </div>
                  <div className="card__middle-row card__middle-row--sport-name">{t(`sport_${sportKey}`)}</div>
                </div>
              </Link>
            </div>
          )
        })}
        {races.length > visibleRaces.length && (
          <div className="extra_card col-xs-12 col-sm-6 col-md-4 col-lg-3">
            <Button onClick={() => setShowAll(true)}>{t('showAll')}</Button>
          </div>
        )}
        {children && <div className="extra_card col-xs-12 col-sm-6 col-md-4 col-lg-3">{children}</div>}
      </div>
    </>
  )
}
