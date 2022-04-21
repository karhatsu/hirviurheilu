import React from 'react'
import useTitle from '../../util/useTitle'
import useTranslation from '../../util/useTranslation'
import Message from '../../common/Message'
import Races from '../home/Races'
import SearchForm from './SearchForm'
import Spinner from '../../common/Spinner'
import Button from '../../common/Button'
import { buildRootPath } from '../../util/routeUtil'
import useRacesPage from './useRacesPage'

export default function RacesPage() {
  const { t } = useTranslation()
  const { data, error, fetching } = useRacesPage()

  useTitle(t('races'))

  const hasRaces = data && (data.future.length || data.today.length || data.past.length)
  return (
    <div>
      <SearchForm />
      {fetching && !data && <Spinner />}
      {!fetching && error && <Message type="error">{error}</Message>}
      {data && (
        <>
          {!hasRaces && <Message type="info">{t('racesNotFound')}</Message>}
          <Races races={data.today} icon="today" titleKey="races_today" />
          <Races races={data.future} icon="today" titleKey="races_future" />
          <Races races={data.past} icon="today" titleKey="races_past" />
        </>
      )}
      <div className="buttons buttons--nav">
        <Button to={buildRootPath()} type="back">{t('backToHomePage')}</Button>
      </div>
    </div>
  )
}
