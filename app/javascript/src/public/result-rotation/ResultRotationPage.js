import React, { useEffect } from 'react'
import useMenu, { pages } from '../../util/useMenu'
import { useRace } from '../../util/useRace'
import IncompletePage from '../../common/IncompletePage'
import useTranslation from '../../util/useTranslation'
import { useResultRotation } from './useResultRotation'
import ResultRotationForm from './ResultRotationForm'
import Button from '../../common/Button'
import { buildRacePath } from '../../util/routeUtil'

export default function ResultRotationPage() {
  const { t } = useTranslation()
  const { setSelectedPage } = useMenu()
  const { fetching, race, error } = useRace()
  useEffect(() => setSelectedPage(pages.resultRotation), [setSelectedPage])

  const { started, stop } = useResultRotation()

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={t('resultRotation')} />
  }

  return (
    <>
      <h2>{t('resultRotation')}</h2>
      {!started && <ResultRotationForm race={race} />}
      {started && (
        <Button onClick={stop} type="primary">{t('resultRotationStop')}</Button>
      )}
      <div className="buttons buttons--nav">
        <Button to={buildRacePath(race.id)} type="back">{t('backToPage', { pageName: race.name })}</Button>
      </div>
    </>
  )
}
