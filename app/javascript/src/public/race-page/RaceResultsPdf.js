import React from 'react'
import isAfter from 'date-fns/isAfter'
import parseISO from 'date-fns/parseISO'
import useTranslation from '../../util/useTranslation'
import ClubSelect from './ClubSelect'

export default function RaceResultsPdf({ race }) {
  const { t } = useTranslation()
  const { clubLevel, clubs, series, startDate } = race
  if (!series.length || isAfter(parseISO(startDate), new Date())) return null
  return (
    <>
      <h2>{t('raceResultsPdf')}</h2>
      <form action={`/races/${race.id}.pdf`} method="GET" className="form">
        <div className="form__horizontal-fields">
          <div className="form__field">
            <ClubSelect clubLevel={clubLevel} clubs={clubs} />
          </div>
          <div className="form__field">
            <input type="checkbox" name="page_breaks" />
            <label htmlFor="page_breaks">{t('pdfPageBreaks')}</label>
          </div>
          <div className="form__buttons">
            <input type="submit" value={t('downloadAllResults')} className="button button--pdf" />
          </div>
        </div>
      </form>
    </>
  )
}
