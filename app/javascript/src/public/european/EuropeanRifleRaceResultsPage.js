import React, { useCallback, useEffect } from 'react'
import useMenu, { pages } from '../../util/useMenu'
import useLayout from '../../util/useLayout'
import useTitle from '../../util/useTitle'
import useTranslation from '../../util/useTranslation'
import { useParams } from 'react-router'
import ResultsWithShots from '../series-results/ResultsWithShots'
import EuropeanRifleDesktopResults from './EuropeanRifleDesktopResults'
import Button from '../../common/Button'
import { buildRacePath, buildRaceRifleResultsPath } from '../../util/routeUtil'
import EuropeanRifleMobileResults from './EuropeanRifleMobileResults'
import useRaceData from '../../util/useRaceData'
import IncompletePage from '../../common/IncompletePage'
import useDataReloading from '../../util/useDataReloading'

export default function EuropeanRifleRaceResultsPage() {
  const { t } = useTranslation()
  const { setSelectedPage } = useMenu()
  const { raceId } = useParams()
  const { mobile } = useLayout()
  const buildApiPath = useCallback(raceId => `/api/v2/public/races/${raceId}/rifle`, [])
  const { error, fetching, race, raceData, reloadDataRef } = useRaceData(buildApiPath)

  useTitle(race && [t('rifle'), race.name, t(`sport_${race.sportKey}`)])
  useEffect(() => setSelectedPage(pages.europeanRifle), [setSelectedPage])

  useDataReloading('RaceChannel', 'race_id', raceId, reloadDataRef)

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={t('rifle')} />
  }

  return (
    <>
      <h2>{t('rifle')}</h2>
      <ResultsWithShots competitors={raceData.competitors}>
        {!mobile && <EuropeanRifleDesktopResults race={race} competitors={raceData.competitors} />}
        {mobile && <EuropeanRifleMobileResults race={race} competitors={raceData.competitors} />}
        <div className="buttons">
          <Button href={`${buildRaceRifleResultsPath(race.id)}.pdf`} type="pdf">
            {t('downloadResultsPdf')}
          </Button>
        </div>
      </ResultsWithShots>
      <div className="buttons buttons--nav">
        <Button to={buildRacePath(race.id)} type="back">{t('backToPage', { pageName: race.name })}</Button>
      </div>
    </>
  )
}
