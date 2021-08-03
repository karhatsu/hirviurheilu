import React, { useEffect, useState } from 'react'
import useTranslation from '../../util/useTranslation'
import useTitle from '../../util/useTitle'
import { get } from '../../util/apiClient'
import IncompletePage from '../../common/IncompletePage'
import Announcement from './Announcement'
import Button from '../../common/Button'

export default function AnnouncementsPage() {
  const { t } = useTranslation()
  const [announcements, setAnnouncements] = useState()
  const [error, setError] = useState()
  useTitle(t('announcements'))

  useEffect(() => {
    get('/api/v2/public/announcements', (err, data) => {
      if (err) setError('Odottamaton virhe, yritä uudestaan')
      else setAnnouncements(data.announcements)
    })
  }, [])

  if (error || !announcements) {
    return <IncompletePage fetching={!error && !announcements} error={error} />
  }

  return (
    <>
      {announcements.map(a => <Announcement announcement={a} key={a.id} />)}
      <div className="buttons buttons--nav">
        <Button to="/" type="back">{t('backToHomePage')}</Button>
      </div>
    </>
  )
}
