import React from 'react'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'
import { buildRootPath } from '../../util/routeUtil'
import Message from '../../common/Message'

export default function ThankYouView() {
  const { t } = useTranslation()
  return (
    <div>
      <h2>{t('feedbackThankYou')}</h2>
      <Message type="info">{t('feedbackSentInfo')}</Message>
      <div className="buttons buttons--nav">
        <Button to={buildRootPath()} type="back">{t('backToHomePage')}</Button>
      </div>
    </div>
  )
}
