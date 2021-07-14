import React from 'react'
import useTranslation from '../../util/useTranslation'

export default function SeriesSelect({ series, onChange }) {
  const { t } = useTranslation()
  return (
    <select name="series_id" onChange={onChange}>
      <option value={''}>{t('allSeries') }</option>
      {series.map(s => {
        return <option key={s.id} value={s.id}>{s.name}</option>
      })}
    </select>
  )
}
