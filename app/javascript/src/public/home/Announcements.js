import React from 'react'
import { Link } from 'react-router-dom'
import format from 'date-fns/format'
import useTranslation from '../../util/useTranslation'
import { buildAnnouncementPath } from '../../util/routeUtil'
import Button from '../../common/Button'

export default function Announcements({ announcements, emphasizeTitle }) {
  const { t } = useTranslation()
  if (!announcements.length) return null
  return (
    <>
      <h2 className={emphasizeTitle ? 'emphasize' : ''}>
        <i className="material-icons-outlined md-18">info</i>
        {t('latestAnnouncements')}
      </h2>
      <div className="row" id="home_page_announcements">
        {announcements.map(({ id, title, published }) => {
          const date = format(new Date(published), 'dd.MM.yyyy')
          return (
            <div key={id} className="col-xs-12 col-sm-6 col-md-4">
              <Link to={buildAnnouncementPath(id)} className="card">
                <div className="card__middle">
                  <div className="card__name">{title}</div>
                  <div className="card__middle-row">{date}</div>
                </div>
              </Link>
            </div>
          )
        })}
        <div className="extra_card col-xs-12 col-sm-6 col-md-4">
          <Button to="/announcements">{t('allAnnouncements')}</Button>
        </div>
      </div>
    </>
  )
}
