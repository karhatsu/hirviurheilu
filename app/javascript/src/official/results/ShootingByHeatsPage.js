import useTranslation from "../../util/useTranslation"
import useOfficialMenu from "../menu/useOfficialMenu"
import { useCallback, useEffect, useMemo, useState } from "react"
import { useRace } from "../../util/useRace"
import useTitle from "../../util/useTitle"
import IncompletePage from "../../common/IncompletePage"
import useOfficialRaceCompetitors from "./useOfficialRaceCompetitors"
import Message from "../../common/Message"
import ShootingRaceShootingForm, { limits  } from "./ShootingRaceShootingForm"
import Button from "../../common/Button"
import { buildOfficialRacePath } from "../../util/routeUtil"

const titleKey = 'officialRaceMenuShootingByHeats'

const HeatOptions = ({ heats, label }) => (
  heats.map(({id, number}) => <option key={id} value={id}>{label} {number}</option>)
)

const ShootingByHeatsPage = () => {
  const { t } = useTranslation()
  const { setSelectedPage } = useOfficialMenu()
  const { error, fetching, race } = useRace()
  const { competitors: allCompetitors } = useOfficialRaceCompetitors()
  const [heat, setHeat] = useState()

  useEffect(() => setSelectedPage('shootingByHeats'), [setSelectedPage])
  useTitle(race && `${t(titleKey)} - ${race.name}`)

  const competitors = useMemo(() => {
    if (!heat) return []
    return allCompetitors?.filter(competitor => {
      const { qualificationRoundHeatId, finalRoundHeatId } = competitor
      return qualificationRoundHeatId === heat.id || finalRoundHeatId === heat.id
    })
  }, [allCompetitors, heat])

  const selectHeat = useCallback(event => {
    const heatId = parseInt(event.target.value)
    setHeat(race.qualificationRoundHeats.find(h => h.id === heatId) || race.finalRoundHeats.find(h => h.id === heatId))
  }, [race])

  if (!race || !allCompetitors) {
    return <IncompletePage title={t(titleKey)} error={error} fetching={fetching} />
  }

  const content = () => {
    if (!allCompetitors.length) return <Message type="info">{t('noCompetitorsInRace')}</Message>
    if (!race.qualificationRoundHeats.length && !race.finalRoundHeats.length) {
      return <Message type="info">{t('noHeats')}</Message>
    }
    return (
      <>
        <div className="form__field">
          <select onChange={selectHeat} value={heat?.id || ''}>
            <option value="">{t('selectHeat')}</option>
            <HeatOptions heats={race.qualificationRoundHeats} label={t('qualificationRoundHeat')} />
            <HeatOptions heats={race.finalRoundHeats} label={t('finalRoundHeat')} />
          </select>
        </div>
        {heat && (
          <h3>
            {t(heat.finalRound ? 'finalRoundHeat' : 'qualificationRoundHeat')} {heat.number}
            {heat.track ? ` (${t('track').toLowerCase()} ${heat.track})` : ''}
          </h3>
        )}
        {heat && !competitors.length && <Message type="info">{t('noCompetitorsInHeat')}</Message>}
        {competitors.length > 0 && (
          <div className="row">
            {competitors.map(competitor => (
              <div key={competitor.id} className="col-sm-12">
                <ShootingRaceShootingForm
                  competitor={competitor}
                  sport={race.sport}
                  limit={heat.finalRound ? limits.final : limits.qr}
                />
              </div>
            ))}
          </div>
        )}
      </>
    )
  }

  return (
    <div>
      <h2>{t(titleKey)}</h2>
      {content()}
      <div className="buttons buttons--nav">
        <Button href={buildOfficialRacePath(race.id)} type="back">{t('backToOfficialRacePage')}</Button>
      </div>
    </div>
  )
}

export default ShootingByHeatsPage
