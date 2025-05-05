import useOfficialMenu from "../menu/useOfficialMenu"
import { useCallback, useEffect, useMemo, useState } from "react"
import Button from "../../common/Button"
import { buildOfficialRaceCompetitorsPath, buildOfficialRacePath } from "../../util/routeUtil"
import { useParams } from "react-router"
import { useRace } from "../../util/useRace"
import useTitle from "../../util/useTitle"
import IncompletePage from "../../common/IncompletePage"
import useTranslation from "../../util/useTranslation"
import { findSeriesById } from "../../util/seriesUtil"
import { del, get } from "../../util/apiClient"
import CompetitorForm from "./CompetitorForm"

const titleKey = 'editCompetitor'

const EditCompetitorPage = () => {
  const { t } = useTranslation()
  const params = useParams()
  const [seriesId, setSeriesId] = useState(parseInt(params.seriesId))
  const [competitor, setCompetitor] = useState()
  const [competitorError, setCompetitorError] = useState()
  const { setSelectedPage } = useOfficialMenu()
  const { race, error, fetching } = useRace()

  useEffect(() => setSelectedPage('competitors'), [setSelectedPage])
  useTitle(race && `${t(titleKey)} - ${race.name}`)

  useEffect(() => {
    const { raceId, seriesId, competitorId } = params
    get(`/official/races/${raceId}/series/${seriesId}/competitors/${competitorId}.json`, (err, response) => {
      if (err) setCompetitorError(err)
      else setCompetitor(response)
    })
  }, [params])

  const series = useMemo(() => race && findSeriesById(race.series, seriesId), [race, seriesId])

  const availableSeries = useMemo(() => {
    return race?.series.filter(s => s.hasStartList === series.hasStartList) || []
  }, [race, series])

  const onSave = useCallback(competitor => {
    window.location.href = buildOfficialRaceCompetitorsPath(params.raceId, competitor.seriesId)
  }, [params])

  const onDelete = useCallback(() => {
    if (confirm(t('deleteCompetitorConfirmation'))) {
      const { raceId, seriesId, competitorId } = params
      del(`/official/races/${raceId}/series/${seriesId}/competitors/${competitorId}.json`, () => {
        window.location.href = buildOfficialRaceCompetitorsPath(raceId, seriesId)
      })
    }
  }, [t, params])

  if (!race || !competitor) {
    return <IncompletePage title={t(titleKey)} error={error || competitorError} fetching={fetching} />
  }

  return (
    <div>
      <h2>{competitor.lastName} {competitor.firstName} - {t(titleKey)}</h2>
      <CompetitorForm
        availableSeries={availableSeries}
        race={race}
        competitor={competitor}
        onSeriesChange={setSeriesId}
        onSave={onSave}
      />
      <div className="buttons buttons--nav">
        <Button href={buildOfficialRaceCompetitorsPath(race.id, seriesId)} type="back">
          {t('backToOfficialSeriesPage', { seriesName: series.name })}
        </Button>
        <Button href={buildOfficialRacePath(race.id)} type="back">{t('backToOfficialRacePage')}</Button>
        <Button onClick={onDelete} type="danger">{t('deleteCompetitor')}</Button>
      </div>
    </div>
  )
}

export default EditCompetitorPage
