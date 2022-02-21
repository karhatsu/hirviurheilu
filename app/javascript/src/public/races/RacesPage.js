import React, { useCallback, useState } from 'react'
import useTitle from '../../util/useTitle'
import useTranslation from '../../util/useTranslation'
import { buildQueryParams, get } from '../../util/apiClient'
import Message from '../../common/Message'
import Races from '../home/Races'
import SearchForm from './SearchForm'
import Spinner from '../../common/Spinner'
import Button from '../../common/Button'
import { buildRootPath } from '../../util/routeUtil'

export default function RacesPage() {
  const { t } = useTranslation()
  const [fetching, setFetching] = useState(true)
  const [data, setData] = useState(undefined)
  const [error, setError] = useState(undefined)

  useTitle(t('races'))

  const search = useCallback(searchParams => {
    setFetching(true)
    const query = { ...searchParams, grouped: true }
    const path = `/api/v2/public/races?${buildQueryParams(query)}`
    get(path, (err, data) => {
      if (err) setError(err)
      else setData(data)
      setFetching(false)
    })
  }, [])

  const hasRaces = data && (data.future.length || data.today.length || data.past.length)
  return (
    <div>
      <SearchForm search={search} />
      {fetching && <Spinner />}
      {!fetching && error && <Message type="error">{error}</Message>}
      {!fetching && data && (
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
