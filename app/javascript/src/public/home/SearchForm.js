import React from 'react'
import useTranslation from '../../util/useTranslation'
import Spinner from '../../common/Spinner'
import { sportKeys } from '../../util/sportUtil'
import useDistricts from '../../util/useDistricts'

export default function SearchForm({ sportKey, setSportKey, districtId, setDistrictId, searching }) {
  const { t } = useTranslation()
  const { districts } = useDistricts()
  return (
    <div className="form__horizontal-fields">
      <div className="form__field">
        <select value={sportKey} onChange={e => setSportKey(e.target.value)} id="sport_key">
          <option value="">{t('allSports')}</option>
          {sportKeys.map(key => <option value={key} key={key}>{t(`sport_${key}`)}</option>)}
        </select>
      </div>
      {districts.length > 0 && (
        <div className="form__field">
          <select value={districtId} onChange={e => setDistrictId(e.target.value)} id="district_id">
            <option value="">{t('allDistricts')}</option>
            {districts.map(({ id, name }) => <option value={id} key={id}>{name}</option>)}
          </select>
        </div>
      )}
      {searching && (
        <div className="form__field"><Spinner /></div>
      )}
    </div>
  )
}
