import { useCallback, useEffect } from 'react'
import useMenu, { pages } from '../../util/useMenu'
import useLayout from '../../util/useLayout'
import useTitle from '../../util/useTitle'
import useTranslation from '../../util/useTranslation'
import { useParams } from 'react-router'
import ResultsWithShots from '../series-results/ResultsWithShots'
import EuropeanShotgunDesktopResults from './EuropeanShotgunDesktopResults'
import Button from '../../common/Button'
import { buildRacePath, buildRaceShotgunsResultsPath } from '../../util/routeUtil'
import EuropeanShotgunMobileResults from './EuropeanShotgunMobileResults'
import useRaceData from '../../util/useRaceData'
import IncompletePage from '../../common/IncompletePage'
import useDataReloading from '../../util/useDataReloading'

export default function EuropeanShotgunRaceResultsPage() {
  const { t } = useTranslation()
  const { setSelectedPage } = useMenu()
  const { raceId } = useParams()
  const { mobile } = useLayout()
  const buildApiPath = useCallback(raceId => `/api/v2/public/races/${raceId}/shotguns`, [])
  const { error, fetching, race, raceData, reloadDataRef } = useRaceData(buildApiPath)

  useTitle(race && [t('european_shotgun'), race.name, t(`sport_${race.sportKey}`)])
  useEffect(() => setSelectedPage(pages.europeanShotgun), [setSelectedPage])

  useDataReloading('RaceChannel', 'race_id', raceId, reloadDataRef)

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={t('european_shotgun')} />
  }

  return (
    <>
      <h2>{t('european_shotgun')}</h2>
      <ResultsWithShots competitors={raceData.competitors}>
        {!mobile && <EuropeanShotgunDesktopResults race={race} competitors={raceData.competitors} />}
        {mobile && <EuropeanShotgunMobileResults competitors={raceData.competitors} />}
        <div className="buttons">
          <Button href={`${buildRaceShotgunsResultsPath(race.id)}.pdf`} type="pdf">
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
