import React, { useEffect, useState } from 'react'
import useOfficialMenu from "../menu/useOfficialMenu"
import { pages } from "../../util/useMenu"
import useTranslation from "../../util/useTranslation"
import Button from "../../common/Button"
import { buildOfficialEventPath } from "../../util/routeUtil"
import { useParams } from "react-router"

const types = ['list', 'numbers']
const competitorOrders = ['alphabetical', 'clubAlphabetical', 'numbers', 'clubNumbers']

const PrintsPage = () => {
  const { t } = useTranslation()
  const { eventId } = useParams()
  const { setSelectedPage } = useOfficialMenu()
  const [type, setType] = useState(types[0])

  useEffect(() => setSelectedPage(pages.events.prints), [setSelectedPage])

  return (
    <div>
      <h2>{t('officialEventMenuPrints')}</h2>
      <form className="form" method="GET" action={`/official/events/${eventId}/prints.pdf`} target="_blank">
        <div className="form__field">
          <label>{t('eventPrintCompetitorType')}</label>
          {types.map(_type => (
            <div key={_type} className="form__horizontal-fields">
              <div className="form__field">
                <input
                  type="radio"
                  name="type"
                  id={_type}
                  checked={_type === type}
                  value={_type}
                  onChange={e => setType(e.target.value)}
                />
                <label htmlFor={_type}>
                  {t(`eventPrintCompetitorType_${_type}`)}
                </label>
              </div>
            </div>
          ))}
        </div>
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
        {type === 'list' && (
          <div className="form__horizontal-fields">
            <div className="form__field">
              <input type="checkbox" name="withRaces" />
              <label htmlFor="withRaces">{t('eventPrintCompetitorWithRaces')}</label>
            </div>
          </div>
        )}
        {type === 'numbers' && (
          <div className="form__horizontal-fields">
            <div className="form__field">
              <input type="radio" name="size" id="size_a4" value="a4" defaultChecked={true} />
              <label htmlFor="size_a4">1 / A4</label>
            </div>
            <div className="form__field">
              <input type="radio" name="size" id="size_a5" value="a5" />
              <label htmlFor="size_a5">2 / A4</label>
            </div>
          </div>
        )}
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
