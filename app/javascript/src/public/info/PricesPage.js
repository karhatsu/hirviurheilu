import { useEffect } from 'react'
import useMenu, { pages } from '../../util/useMenu'
import useTitle from '../../util/useTitle'
import useTranslation from '../../util/useTranslation'
import Message from '../../common/Message'
import Button from '../../common/Button'
import { buildFeedbackPath, buildRootPath } from '../../util/routeUtil'

export default function PricesPage() {
  const { t } = useTranslation()
  const { setSelectedPage } = useMenu()
  useTitle(t('prices'))
  useEffect(() => setSelectedPage(pages.info.prices), [setSelectedPage])
  return (
    <div>
      <h2>Metsästäjäliiton jäsenseurat</h2>
      <Message type="important">
        Hirviurheilu on Metsästäjäliiton jäsenseurojen vapaassa käytössä ilman erillistä veloitusta
      </Message>
      <h2>Muut käyttäjät</h2>
      <Button href={buildFeedbackPath()}>Ota yhteyttä, niin sovitaan tilanteeseen sopiva hinta</Button>
      <div className="buttons buttons--nav">
        <Button to={buildRootPath()} type="back">
          {t('backToHomePage')}
        </Button>
      </div>
    </div>
  )
}
