import React, { useCallback, useEffect } from 'react'
import { useParams } from 'react-router-dom'
import useMenu, { pages } from '../../util/useMenu'
import useTranslation from '../../util/useTranslation'
import useTitle from '../../util/useTitle'
import ResultsWithShots from '../series-results/ResultsWithShots'
import useLayout from '../../util/useLayout'
import NordicSubSportDesktopResults from './NordicSubSportDesktopResults'
import Button from '../../common/Button'
import { buildNordicResultsPath, buildRacePath } from '../../util/routeUtil'
import NordicSubSportMobileResults from './NordicSubSportMobileResults'
import NordicSubSportMobileSubMenu from './NordicSubSportMobileSubMenu'
import useRaceData from '../../util/useRaceData'
import IncompletePage from '../../common/IncompletePage'

export default function NordicSubSportResultsPage() {
  const { t } = useTranslation()
  const { setSelectedPage } = useMenu()
  const { subSport } = useParams()
  const { mobile } = useLayout()
  const buildApiPath = useCallback(raceId => `/api/v2/public/races/${raceId}/${subSport}`, [subSport])
  const { error, fetching, race, raceData: results } = useRaceData(buildApiPath)

  const title = t(`nordic_${subSport}`)
  useTitle(race && `${race.name} - ${title}`)
  useEffect(() => {
    setSelectedPage(pages.nordic[subSport])
  }, [setSelectedPage, subSport])

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={title} />
  }

  return (
    <>
      <h2>{title}</h2>
      <ResultsWithShots competitors={results.competitors}>
        {!mobile && <NordicSubSportDesktopResults race={race} competitors={results.competitors} />}
        {mobile && <NordicSubSportMobileResults race={race} competitors={results.competitors} />}
        {mobile && <NordicSubSportMobileSubMenu race={race} currentSubSport={subSport} />}
        <div className="buttons">
          <Button href={`${buildNordicResultsPath(race.id, subSport)}.pdf`} type="pdf">
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
