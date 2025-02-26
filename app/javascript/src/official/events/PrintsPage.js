import React, { useEffect } from 'react'
import useOfficialMenu from "../menu/useOfficialMenu"
import { pages } from "../../util/useMenu"
import useTranslation from "../../util/useTranslation"
import Button from "../../common/Button"
import { buildOfficialEventPath } from "../../util/routeUtil"
import { useParams } from "react-router"

const competitorOrders = ['alphabetical', 'clubAlphabetical', 'numbers', 'clubNumbers']

const PrintsPage = () => {
  const { t } = useTranslation()
  const { eventId } = useParams()
  const { setSelectedPage } = useOfficialMenu()

  useEffect(() => setSelectedPage(pages.events.prints), [setSelectedPage])

  return (
    <div>
      <h2>{t('officialEventMenuPrints')}</h2>
      <form className="form" method="GET" action={`/official/events/${eventId}/prints.pdf`} target="_blank">
        <div className="form__field">
          <label>{t('eventPrintCompetitorOrder')}</label>
          {competitorOrders.map(order => (
            <div key={order} className="form__horizontal-fields">
              <div className="form__field">
                <input type="radio" name="order" id={order} defaultChecked={order === 'alphabetical'} value={order}/>
                <label htmlFor={order}>
                  {t(`eventPrintCompetitorOrder_${order}`)}
                </label>
              </div>
            </div>
          ))}
        </div>
        <div className="form__field">
          <label>{t('eventPrintCompetitorOptions')}</label>
        </div>
        <div className="form__horizontal-fields">
          <div className="form__field">
            <input type="checkbox" name="withRaces" />
            <label htmlFor="withRaces">{t('eventPrintCompetitorWithRaces')}</label>
          </div>
        </div>
        <div className="form__buttons">
          <Button submit={true} type="primary">{t('printPdf')}</Button>
        </div>
      </form>
      <div className="buttons buttons--nav">
        <Button to={buildOfficialEventPath(eventId)} type="back">{t('backToOfficialEventPage')}</Button>
      </div>
    </div>
  )
}

export default PrintsPage
