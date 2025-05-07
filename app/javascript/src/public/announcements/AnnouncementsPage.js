import { useEffect, useState } from 'react'
import useTranslation from '../../util/useTranslation'
import useTitle from '../../util/useTitle'
import { get } from '../../util/apiClient'
import IncompletePage from '../../common/IncompletePage'
import Announcement from './Announcement'
import Button from '../../common/Button'
import { buildRootPath } from '../../util/routeUtil'

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
      <div className="announcements">
        {announcements.map((a) => (
          <Announcement announcement={a} key={a.id} />
        ))}
      </div>
      <div className="buttons buttons--nav">
        <Button to={buildRootPath()} type="back">
          {t('backToHomePage')}
        </Button>
      </div>
    </>
  )
}
