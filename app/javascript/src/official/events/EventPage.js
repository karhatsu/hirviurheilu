import { useEffect } from 'react'
import IncompletePage from '../../common/IncompletePage'
import useTitle from '../../util/useTitle'
import Button from '../../common/Button'
import useTranslation from '../../util/useTranslation'
import useOfficialMenu from '../menu/useOfficialMenu'
import { pages } from '../../util/useMenu'
import { useEvent } from '../../util/useEvent'
import { buildOfficialRacePath } from '../../util/routeUtil'

const EventPage = () => {
  const { t } = useTranslation()
  const { fetching, event, error } = useEvent()
  const { setSelectedPage } = useOfficialMenu()
  useTitle(event?.name)

  useEffect(() => setSelectedPage(pages.events.main), [setSelectedPage])

  if (fetching || error) return <IncompletePage fetching={fetching} error={error} />

  return (
    <div>
      <h3>{t('eventRaces')}</h3>
      <div>
        {event.races.map((race) => (
          <div key={race.id}>
            <a href={buildOfficialRacePath(race.id)}>{race.name}</a>
          </div>
        ))}
      </div>
      <div className="buttons">
        <Button to={`edit`} type="edit">
          {t('eventEdit')}
        </Button>
      </div>
      <div className="buttons buttons--nav">
        <Button href="/official" type="back">
          {t('backToOfficialIndexPage')}
        </Button>
      </div>
    </div>
  )
}

export default EventPage
