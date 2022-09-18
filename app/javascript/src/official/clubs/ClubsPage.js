import React from 'react'
import Button from '../../common/Button'
import { buildRootPath } from '../../util/routeUtil'
import useTranslation from '../../util/useTranslation'

const ClubsPage = () => {
  const { t } = useTranslation()
  return (
    <div>
      <h2>CLUBS</h2>
      <div className="buttons buttons--nav">
        <Button to={buildRootPath()} type="back">{t('backToOfficialRacePage')}</Button>
      </div>
    </div>
  )
}

export default ClubsPage
