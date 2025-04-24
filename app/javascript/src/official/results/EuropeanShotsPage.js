import useOfficialMenu from "../menu/useOfficialMenu"
import { useEffect, useMemo, useState } from "react"
import { useRace } from "../../util/useRace"
import IncompletePage from "../../common/IncompletePage"
import useTranslation from "../../util/useTranslation"
import Button from "../../common/Button"
import { buildOfficialRacePath } from "../../util/routeUtil"
import Message from "../../common/Message"
import useOfficialRaceCompetitors from "./useOfficialRaceCompetitors"
import useTitle from "../../util/useTitle"
import { capitalize } from "./resultUtil"
import EuropeanShotsForm from "./EuropeanShotsForm"

const EuropeanShotsPage = ({ subSport }) => {
  const { t } = useTranslation()
  const { setSelectedPage } = useOfficialMenu()
  const { race, error, fetching } = useRace()
  const titleKey = `european_${subSport}`
  const { competitors: allCompetitors } = useOfficialRaceCompetitors()
  const [seriesId, setSeriesId] = useState(-1)
  const [heatId, setHeatId] = useState(-2)

  useEffect(() => setSelectedPage(capitalize(`european_${subSport}`)), [setSelectedPage, subSport])
  useTitle(race && `${t(titleKey)} - ${race.name}`)

  const competitors = useMemo(() => {
    return allCompetitors?.filter(competitor => {
      const { qualificationRoundHeatId, finalRoundHeatId } = competitor
      return (seriesId === -1 || competitor.seriesId === seriesId)
        && (heatId === -2 || (qualificationRoundHeatId === heatId || finalRoundHeatId === heatId))
    }).sort((a, b) => {
      if (heatId !== -2 && a.qualificationRoundTrackPlace !== b.qualificationRoundTrackPlace) {
        return a.qualificationRoundTrackPlace - b.qualificationRoundTrackPlace
      } else if (a.number !== b.number) {
        return a.number - b.number
      } else if (a.lastName !== b.lastName) {
        return a.lastName.localeCompare(a.lastName)
      } else {
        return a.firstName.localeCompare(b.firstName)
      }
    })
  }, [allCompetitors, seriesId, heatId])

  const config = useMemo(() => ({
    fieldNames: {
      scoreInput: capitalize(`european_${subSport}ScoreInput`),
      shots: capitalize(`european_${subSport}Shots`),
    },
    shotCount: ['trap', 'compak'].includes(subSport) ? 25 : 10,
    bestShotValue: ['trap', 'compak'].includes(subSport) ? 1 : 10,
  }), [subSport])

  if (!race || !competitors) return <IncompletePage title={t(titleKey)} error={error} fetching={fetching}/>

  return (
    <div>
      <h2>{t(titleKey)}</h2>
      {!allCompetitors.length && <Message type="info">{t('noCompetitorsInRace')}</Message>}
      {allCompetitors.length > 0 && (
        <>
          <Message type="info">{t('eitherTotalScoreOrShots')}</Message>
          {(race.series.length > 1 || race.qualificationRoundHeats.length > 1) && (
            <div className="form__field form__field--md">
              {race.series.length > 1 && (
                <select
                  onChange={e => setSeriesId(parseInt(e.target.value) || -1)}
                  value={seriesId}
                  style={{ marginRight: 8 }}
                >
                  <option value={-1}>{t('allSeries')}</option>
                  {race.series.map(({ id, name }) => <option key={id} value={id}>{name}</option>)}
                </select>
              )}
              {race.qualificationRoundHeats.length > 1 && (
                <select onChange={e => setHeatId(parseInt(e.target.value) || -2)} value={heatId}>
                  <option value={-2}>{t('allHeats')}</option>
                  {race.qualificationRoundHeats.map(({ id, number }) => <option key={id} value={id}>{number}</option>)}
                </select>
              )}
            </div>
          )}
          <div className="row">
            {competitors.map(competitor => (
              <div key={competitor.id} className="col-sm-12">
                <EuropeanShotsForm
                  competitor={competitor}
                  subSport={subSport}
                  config={config}
                  withTrackPlace={heatId !== -2}
                />
              </div>
            ))}
          </div>
        </>
      )}
      <div className="buttons buttons--nav">
        <Button href={buildOfficialRacePath(race.id)} type="back">{t('backToOfficialRacePage')}</Button>
      </div>
    </div>
  )
}

export default EuropeanShotsPage
