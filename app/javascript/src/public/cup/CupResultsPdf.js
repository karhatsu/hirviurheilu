import React from 'react'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'
import { buildCupPath } from '../../util/routeUtil'

export default function CupResultsPdf({ cup }) {
  const { t } = useTranslation()
  const { cupSeries } = cup
  if (!cupSeries.length) return null
  return (
    <>
      <h2>{t('raceResultsPdf')}</h2>
      <form action={`${buildCupPath(cup.id)}.pdf`} method="GET" className="form">
        <div className="form__horizontal-fields">
          <div className="form__field">
            <input type="checkbox" name="page_breaks" />
            <label htmlFor="page_breaks">{t('pdfPageBreaks')}</label>
          </div>
          <div className="form__buttons">
            <Button submit={true} type="primary">{t('downloadAllResults')}</Button>
          </div>
        </div>
      </form>
    </>
  )
}
