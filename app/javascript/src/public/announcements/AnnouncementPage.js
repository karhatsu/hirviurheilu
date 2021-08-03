import React, { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import { get } from '../../util/apiClient'
import IncompletePage from '../../common/IncompletePage'
import useTranslation from '../../util/useTranslation'
import useTitle from '../../util/useTitle'
import Button from '../../common/Button'
import format from 'date-fns/format'

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
    return <IncompletePage fetching={!error && !announcement} error={error} title={t('announcements')} />
  }

  const { title, published, content } = announcement
  return (
    <>
      <h2>{title}</h2>
      <h3>{format(new Date(published), 'dd.MM.yyyy')}</h3>
      <div dangerouslySetInnerHTML={{ __html: content }}/>
      <div className="buttons buttons--nav">
        <Button to="/" type="back">{t('backToHomePage')}</Button>
        <Button href="/announcements">{t('allAnnouncements')}</Button>
      </div>
    </>
  )
}
