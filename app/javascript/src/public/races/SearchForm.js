import React, { useCallback, useState } from 'react'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'
import { sportKeys } from '../../util/sportUtil'
import useDistricts from '../../util/useDistricts'

const emptySearchParams = { search_text: '', sport_key: '', district_id: '', time: '' }

export default function SearchForm({ onSearch }) {
  const { t } = useTranslation()
  const [searchParams, setSearchParams] = useState(emptySearchParams)
  const { districts } = useDistricts()

  const setSearchValue = useCallback(key => event => {
    setSearchParams(params => {
      return { ...params, [key]: event.target.value }
    })
  }, [])

  const submit = useCallback(() => onSearch(searchParams), [onSearch, searchParams])
  const reset = useCallback(() => {
    setSearchParams(emptySearchParams)
    onSearch({})
  }, [onSearch])

  return (
    <div className="form">
      <div className="form__horizontal-fields">
        <div className="form__field">
          <input
            type="text"
            id="search_text"
            value={searchParams.search_text}
            onChange={setSearchValue('search_text')}
            onKeyPress={e => e.key === 'Enter' && submit()}
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
          <Button type="primary" onClick={submit} id="search">{t('search')}</Button>
          <Button onClick={reset} id="reset">{t('reset')}</Button>
        </div>
      </div>
    </div>
  )
}
