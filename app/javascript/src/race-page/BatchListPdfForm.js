import React from 'react'
import ClubSelect from './ClubSelect'
import SeriesSelect from './SeriesSelect'
import useTranslation from '../util/useTranslation'

export default function BatchListPdfForm({ path, race, title }) {
  const { t } = useTranslation()
  const { clubLevel, clubs, series } = race
  return (
    <>
      <h2>{title} (PDF)</h2>
      <form action={`${path}.pdf`} method="GET" className="form">
        <div className="form__horizontal-fields">
          <div className="form__field">
            <SeriesSelect series={series} />
          </div>
          <div className="form__field">
            <ClubSelect clubLevel={clubLevel} clubs={clubs} />
          </div>
          <div className="form__buttons">
            <input type="submit" value={t('downloadBatchList')} className="button button--pdf" />
          </div>
        </div>
      </form>
    </>
  )
}
