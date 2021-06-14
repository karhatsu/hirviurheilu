import React, { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import { pages } from '../menu/DesktopSecondLevelMenu'
import useTranslation from '../../util/useTranslation'
import { useRace } from '../../util/useRace'
import useTitle from '../../util/useTitle'
import ResultsWithShots from '../series-results/ResultsWithShots'
import { get } from '../../util/apiClient'
import Message from '../../common/Message'
import Spinner from '../../common/Spinner'
import useLayout from '../../util/useLayout'
import NordicSubSportDesktopResults from './NordicSubSportDesktopResults'
import Button from '../../common/Button'
import { buildNordicResultsPath, buildRacePath } from '../../util/routeUtil'
import NordicSubSportMobileResults from './NordicSubSportMobileResults'
import NordicSubSportMobileSubMenu from './NordicSubSportMobileSubMenu'

export default function NordicSubSportResultsPage({ setSelectedPage }) {
  const { t } = useTranslation()
  const { subSport } = useParams()
  const { race } = useRace()
  const [error, setError] = useState()
  const [results, setResults] = useState()
  const { mobile } = useLayout()

  const title = t(`nordic_${subSport}`)
  useTitle(race && `${race.name} - ${title}`)
  useEffect(() => {
    setSelectedPage(pages.nordic[subSport])
  }, [setSelectedPage, subSport])

  useEffect(() => {
    if (race) {
      const path = `/api/v2/public/races/${race.id}/${subSport}`
      get(path, (err, data) => {
        if (err) return setError(err)
        setResults(data)
      })
    }
  }, [race, subSport])

  const content = () => {
    if (error) {
      return <Message type="error">{error}</Message>
    } else if (!race || !results || (results && results.subSport !== subSport)) {
      return <Spinner />
    } else {
      return (
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
      )
    }
  }
  return (
    <>
      <h2>{title}</h2>
      {content()}
      {race && (
        <div className="buttons buttons--nav">
          <Button to={buildRacePath(race.id)} type="back">{t('backToPage', { pageName: race.name })}</Button>
        </div>
      )}
    </>
  )
}
