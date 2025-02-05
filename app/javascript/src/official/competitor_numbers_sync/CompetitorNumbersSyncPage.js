import React from 'react'
import Message from "../../common/Message"
import useTranslation from "../../util/useTranslation"
import Button from "../../common/Button"

const CompetitorNumbersSyncPage = () => {
  const { t } = useTranslation()

  return (
    <div>
      <Message type="info">{t('competitorNumbersSyncInfo')}</Message>
      <div className="buttons buttons--nav">
        <Button href="/official" type="back">{t('backToOfficialIndexPage')}</Button>
      </div>
    </div>
  )
}

export default CompetitorNumbersSyncPage
