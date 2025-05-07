import { useCallback, useEffect } from 'react'
import isAfter from 'date-fns/isAfter'
import parseISO from 'date-fns/parseISO'
import subWeeks from 'date-fns/subWeeks'
import IncompletePage from '../../common/IncompletePage'
import Races from './Races'
import Announcements from './Announcements'
import Button from '../../common/Button'
import useTranslation from '../../util/useTranslation'
import SearchForm from './SearchForm'
import { buildRacesPath } from '../../util/routeUtil'
import useTitle from '../../util/useTitle'
import useHomePage from './useHomePage'

export default function HomePage() {
  const { t } = useTranslation()
  const { data, error, searchParams, setSearchValue, search, searching } = useHomePage()
  useTitle(t('appTitle'))

  const toPastRaces = useCallback(() => {
    document.querySelector('#past-races').scrollIntoView({ behavior: 'smooth' })
  }, [])

  useEffect(() => search(), [search])

  if (error || !data) {
    return <IncompletePage error={error} fetching={!error} />
  }

  const { announcements, today, yesterday, future, past } = data
  const hasRecentAnnouncements = announcements.find((a) => isAfter(parseISO(a.published), subWeeks(new Date(), 2)))
  const pastTitleKey = yesterday.length ? 'races_previously' : 'races_latest'
  return (
    <>
      {hasRecentAnnouncements && (
        <>
          <Announcements announcements={announcements} emphasizeTitle={true} />
          <h2 className="emphasize">{t('races')}</h2>
        </>
      )}
      <SearchForm
        sportKey={searchParams.sport_key}
        setSportKey={setSearchValue('sport_key')}
        districtId={searchParams.district_id}
        setDistrictId={setSearchValue('district_id')}
        level={searchParams.level}
        setLevel={setSearchValue('level')}
        searching={searching}
      />
      <Races races={today} titleKey="races_today" icon="directions_run" sectionId="races_today" />
      <Races races={yesterday} titleKey="races_yesterday" icon="check_circle" sectionId="races_yesterday">
        <Button onClick={toPastRaces} type="down">
          {t('races_previously')}
        </Button>
      </Races>
      <div id="future_races">
        {future.map(({ key, races }) => {
          return <Races key={key} races={races} titleKey={`races_${key}`} icon="today" limit={true} />
        })}
      </div>
      <Races races={past} titleKey={pastTitleKey} icon="check_circle" sectionId="past-races">
        <Button to={buildRacesPath()}>{t('allRaces')}</Button>
      </Races>
      {!hasRecentAnnouncements && <Announcements announcements={announcements} />}
    </>
  )
}
