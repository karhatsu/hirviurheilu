import React from 'react'
import { Link } from 'react-router-dom'
import useTranslation from '../../util/useTranslation'
import { buildRacePath } from '../../util/routeUtil'
import DateInterval from '../../util/DateInterval'

export default function Races({ races, titleKey, icon, sectionId, children }) {
  const { t } = useTranslation()
  if (!races.length) return null
  return (
    <>
      <h2>
        <i className="material-icons-outlined md-18">{icon}</i>
        {t(titleKey)}
      </h2>
      <div id={sectionId} className="row">
        {races.map(race => {
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
        {children && <div className="extra_card col-xs-12 col-sm-6 col-md-4 col-lg-3">{children}</div>}
      </div>
    </>
  )
}
