import useOfficialMenu from '../menu/useOfficialMenu'
import { useCallback, useEffect, useState } from 'react'
import { useRace } from '../../util/useRace'
import IncompletePage from '../../common/IncompletePage'
import useTranslation from '../../util/useTranslation'
import LimitedNewCompetitorForm from './LimitedNewCompetitorForm'
import useTitle from '../../util/useTitle'
import { get } from '../../util/apiClient'
import { useNavigate, useParams } from 'react-router'
import { buildLimitedOfficialCompetitorsPath } from '../../util/routeUtil'

const LimitedEditCompetitorPage = () => {
  const { t } = useTranslation()
  const { raceId, competitorId } = useParams()
  const navigate = useNavigate()
  const { setSelectedPage } = useOfficialMenu()
  const { fetching, error, race } = useRace()
  const [competitor, setCompetitor] = useState()

  useEffect(() => setSelectedPage('competitors'), [setSelectedPage])
  useTitle(race && `Kilpailijat - ${race.name}`, race)

  useEffect(() => {
    get(`/official/limited/races/${raceId}/competitors/${competitorId}.json`, (err, response) => {
      if (err)
        console.log(err) // TODO
      else setCompetitor(response)
    })
  }, [raceId, competitorId])

  const onUpdate = useCallback(() => {
    navigate(buildLimitedOfficialCompetitorsPath(raceId))
  }, [navigate, raceId])

  if (fetching || error || !competitor)
    return <IncompletePage fetching={fetching} error={error} title={t('editCompetitor')} />

  return (
    <div>
      <h2>{t('editCompetitor')}</h2>
      <LimitedNewCompetitorForm race={race} initialCompetitor={competitor} onSave={onUpdate} />
    </div>
  )
}

export default LimitedEditCompetitorPage
