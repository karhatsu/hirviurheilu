import React, { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import { get } from '../../util/apiClient'
import IncompletePage from '../../common/IncompletePage'
import useTranslation from '../../util/useTranslation'
import useTitle from '../../util/useTitle'
import Button from '../../common/Button'
import Announcement from './Announcement'
import { buildAnnouncementsPath, buildRootPath } from '../../util/routeUtil'

export default function AnnouncementPage() {
  const { t } = useTranslation()
  const { announcementId } = useParams()
  const [announcement, setAnnouncement] = useState()
  const [error, setError] = useState()
  useTitle(announcement && announcement.title)

  useEffect(() => {
    get(`/api/v2/public/announcements/${announcementId}`, (err, data) => {
      if (err) setError('Odottamaton virhe, yritä uudestaan')
      else setAnnouncement(data)
    })
  }, [announcementId])

  if (error || !announcement) {
    return <IncompletePage fetching={!error && !announcement} error={error} />
  }

  return (
    <>
      <Announcement announcement={announcement} />
      <div className="buttons buttons--nav">
        <Button to={buildRootPath()} type="back">{t('backToHomePage')}</Button>
        <Button to={buildAnnouncementsPath()}>{t('allAnnouncements')}</Button>
      </div>
    </>
  )
}
