import React, { useCallback, useEffect, useState } from 'react'
import { useHistory, useLocation } from 'react-router-dom'
import debounce from 'lodash.debounce'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'
import { sportKeys } from '../../util/sportUtil'
import useDistricts from '../../util/useDistricts'

const emptySearchParams = { search_text: '', sport_key: '', district_id: '', time: '', level: '' }

const buildDefaultSearchParams = urlSearchParams => {
  const params = { ...emptySearchParams }
  Object.keys(emptySearchParams).forEach(key => {
    params[key] = urlSearchParams.get(key) || ''
  })
  return params
}

const buildURLSearchParams = searchParams => {
  return '?' + Object.keys(searchParams)
    .filter(key => searchParams[key])
    .map(key => `${key}=${encodeURIComponent(searchParams[key])}`)
    .join('&')
}

function useDebounce(callback, delay) {
  // eslint-disable-next-line react-hooks/exhaustive-deps
  return useCallback(debounce((...args) => callback(...args), delay), [delay])
}

export default function SearchForm({ search }) {
  const { t } = useTranslation()
  const history = useHistory()
  const urlSearchParams = new URLSearchParams(useLocation().search)
  const defaultSearchParams = buildDefaultSearchParams(urlSearchParams)
  const [searchText, setSearchText] = useState(defaultSearchParams.search_text || '')
  const [searchParams, setSearchParams] = useState(defaultSearchParams)
  const { districts } = useDistricts()

  const debouncedTextSearch = useDebounce(value => {
    setSearchParams(params => ({ ...params, search_text: value }))
  }, 300)

  const onSearchTextChange = useCallback(event => {
    const { value } = event.target
    setSearchText(value)
    debouncedTextSearch(value)
  }, [debouncedTextSearch])

  const setSearchValue = useCallback(key => event => {
    setSearchParams(params => {
      return { ...params, [key]: event.target.value }
    })
  }, [])

  const reset = useCallback(() => setSearchParams(emptySearchParams), [])

  useEffect(() => {
    history.push(buildURLSearchParams(searchParams))
    search(searchParams)
  }, [history, search, searchParams])

  return (
    <div className="form">
      <div className="form__horizontal-fields">
        <div className="form__field">
          <input
            type="text"
            id="search_text"
            value={searchText}
            onChange={onSearchTextChange}
            placeholder={t('raceSearchPlaceholder')}
            style={{ width: '18em' }}
          />
        </div>
        <div className="form__field">
          <select value={searchParams.sport_key} onChange={setSearchValue('sport_key')} id="sport_key">
            <option value="">{t('allSports')}</option>
            {sportKeys.map(key => <option value={key} key={key}>{t(`sport_${key}`)}</option>)}
          </select>
        </div>
        {districts.length > 0 && (
          <div className="form__field">
            <select value={searchParams.district_id} onChange={setSearchValue('district_id')} id="district_id">
              <option value="">{t('allDistricts')}</option>
              {districts.map(({ id, name }) => <option value={id} key={id}>{name}</option>)}
            </select>
          </div>
        )}
        <div className="form__field">
          <select value={searchParams.level} onChange={setSearchValue('level')} id="level">
            <option value="">{t('allLevels')}</option>
            {[3, 2, 1, 0].map(level => <option value={level} key={level}>{t(`level_${level}`)}</option>)}
          </select>
        </div>
        <div className="form__field">
          <select value={searchParams.time} onChange={setSearchValue('time')} id="time">
            <option value="">{t('noTimeLimit')}</option>
            <option value="future">{t('races_future')}</option>
            <option value="past">{t('races_past')}</option>
          </select>
        </div>
        <div className="form__buttons">
          <Button onClick={reset} id="reset">{t('reset')}</Button>
        </div>
      </div>
    </div>
  )
}
