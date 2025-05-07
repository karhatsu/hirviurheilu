import useOfficialMenu from '../menu/useOfficialMenu'
import { useCallback, useEffect, useMemo, useState } from 'react'
import { useRace } from '../../util/useRace'
import useTitle from '../../util/useTitle'
import IncompletePage from '../../common/IncompletePage'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'
import {
  buildOfficialRaceCompetitorsPath,
  buildOfficialRaceCsvImportPath,
  buildOfficialRacePath,
} from '../../util/routeUtil'
import { useParams } from 'react-router'
import CompetitorForm from './CompetitorForm'
import { findSeriesById } from '../../util/seriesUtil'

const titleKey = 'newCompetitor'

const NewCompetitorPage = () => {
  const { t } = useTranslation()
  const params = useParams()
  const [seriesId, setSeriesId] = useState(parseInt(params.seriesId))
  const { setSelectedPage } = useOfficialMenu()
  const { race, error, fetching, reload: reloadRace } = useRace()
  const initialCompetitor = useMemo(
    () => ({
      seriesId,
      number: race?.nextNumber,
      startTime: race?.nextStartTime,
    }),
    [seriesId, race],
  )
  const [savedCompetitors, setSavedCompetitors] = useState([])

  useEffect(() => setSelectedPage('competitors'), [setSelectedPage])
  useTitle(race && `${t(titleKey)} - ${race.name}`)

  const onSave = useCallback(
    (competitor) => {
      setSavedCompetitors((prev) => [competitor, ...prev])
      if (!race.clubs.find((club) => club.id === competitor.clubId)) {
        reloadRace()
      }
    },
    [race, reloadRace],
  )

  if (!race) return <IncompletePage title={t(titleKey)} error={error} fetching={fetching} />

  const series = findSeriesById(race.series, seriesId)
  return (
    <div>
      <h2>
        {race.name} - {t(titleKey)}
      </h2>
      <CompetitorForm
        availableSeries={race.series}
        race={race}
        competitor={initialCompetitor}
        onSeriesChange={setSeriesId}
        onSave={onSave}
      />
      {savedCompetitors.length > 0 && (
        <div>
          <h3>{t('recentlyAddedCompetitors')}</h3>
          <ul>
            {savedCompetitors.map((competitor, i) => (
              <li key={competitor.id} style={i === 0 ? { color: 'olive', fontWeight: 'bold' } : {}}>
                {competitor.lastName} {competitor.firstName} ({findSeriesById(race.series, competitor.seriesId)?.name})
              </li>
            ))}
          </ul>
        </div>
      )}
      <div className="buttons buttons--nav">
        <Button href={buildOfficialRaceCompetitorsPath(race.id, seriesId)} type="back">
          {t('backToOfficialSeriesPage', { seriesName: series.name })}
        </Button>
        <Button href={buildOfficialRacePath(race.id)} type="back">
          {t('backToOfficialRacePage')}
        </Button>
        <Button href={buildOfficialRaceCsvImportPath(race.id)} type="add">
          {t('addCompetitorsFromCsvFile')}
        </Button>
      </div>
    </div>
  )
}

export default NewCompetitorPage
