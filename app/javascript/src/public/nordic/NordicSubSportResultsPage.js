import { useCallback, useEffect } from 'react'
import { useParams } from 'react-router'
import useMenu, { pages } from '../../util/useMenu'
import useTranslation from '../../util/useTranslation'
import useTitle from '../../util/useTitle'
import ResultsWithShots from '../series-results/ResultsWithShots'
import useLayout from '../../util/useLayout'
import NordicSubSportDesktopResults from './NordicSubSportDesktopResults'
import Button from '../../common/Button'
import { buildNordicResultsPath, buildNordicSeriesResultsPath, buildRacePath } from '../../util/routeUtil'
import NordicSubSportMobileResults from './NordicSubSportMobileResults'
import NordicSubSportMobileSubMenu from './NordicSubSportMobileSubMenu'
import useRaceData from '../../util/useRaceData'
import IncompletePage from '../../common/IncompletePage'
import { findSeriesById } from '../../util/seriesUtil'

export default function NordicSubSportResultsPage() {
  const { t } = useTranslation()
  const { setSelectedPage } = useMenu()
  const { subSport } = useParams()
  const seriesId = parseInt(useParams().seriesId)
  const { mobile } = useLayout()
  const buildApiPath = useCallback(
    (raceId) => {
      return seriesId
        ? `/api/v2/public/races/${raceId}/series/${seriesId}/${subSport}`
        : `/api/v2/public/races/${raceId}/${subSport}`
    },
    [seriesId, subSport],
  )
  const { error, fetching, race, raceData: results } = useRaceData(buildApiPath)

  const titleSeries = race && seriesId && findSeriesById(race.series, seriesId)
  const title = (titleSeries ? `${titleSeries.name} - ` : '') + t(`nordic_${subSport}`)
  useTitle(race && [title, race.name, t(`sport_${race.sportKey}`)])
  useEffect(() => {
    setSelectedPage(pages.nordic[subSport])
  }, [setSelectedPage, subSport])

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={title} />
  }

  const pdfPath = seriesId
    ? buildNordicSeriesResultsPath(race.id, seriesId, subSport)
    : buildNordicResultsPath(race.id, subSport)
  return (
    <>
      <h2>{title}</h2>
      <ResultsWithShots competitors={results.competitors}>
        {!mobile && <NordicSubSportDesktopResults race={race} competitors={results.competitors} />}
        {mobile && <NordicSubSportMobileResults race={race} competitors={results.competitors} />}
        {mobile && <NordicSubSportMobileSubMenu race={race} currentSubSport={subSport} />}
        <div className="buttons">
          <Button href={`${pdfPath}.pdf`} type="pdf">
            {t('downloadResultsPdf')}
          </Button>
        </div>
      </ResultsWithShots>
      <div className="buttons buttons--nav">
        <Button to={buildRacePath(race.id)} type="back">
          {t('backToPage', { pageName: race.name })}
        </Button>
      </div>
    </>
  )
}
