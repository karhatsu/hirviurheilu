import useOfficialMenu from '../menu/useOfficialMenu'
import { useCallback, useEffect, useMemo, useState } from 'react'
import { useRace } from '../../util/useRace'
import IncompletePage from '../../common/IncompletePage'
import useTranslation from '../../util/useTranslation'
import LimitedNewCompetitorForm from './LimitedNewCompetitorForm'
import Message from '../../common/Message'
import useAppData from '../../util/useAppData'
import { del, get } from '../../util/apiClient'
import CompetitorsList from './CompetitorsList'
import useTitle from '../../util/useTitle'

const LimitedNewCompetitorPage = () => {
  const { t } = useTranslation()
  const { setSelectedPage } = useOfficialMenu()
  const { fetching, error, race } = useRace()
  const { userRaceRight } = useAppData()
  const [competitors, setCompetitors] = useState([])

  useEffect(() => setSelectedPage('competitors'), [setSelectedPage])
  useTitle(race && `Kilpailijat - ${race.name}`, race)

  useEffect(() => {
    if (!race) return
    get(`/official/limited/races/${race.id}/competitors.json`, (err, response) => {
      if (err) console.error('Error in fetching competitors', err)
      else setCompetitors(response.competitors)
    })
  }, [race])

  const initialCompetitor = useMemo(
    () => ({
      number: race?.nextNumber,
      startTime: race?.nextStartTime,
      clubId: userRaceRight.clubId || '',
    }),
    [race, userRaceRight],
  )

  const onCreate = useCallback((competitor) => {
    setCompetitors((prev) => {
      const newCompetitors = [...prev]
      newCompetitors.push(competitor)
      newCompetitors.sort((a, b) => a.lastName.localeCompare(b.lastName))
      return newCompetitors
    })
  }, [])

  const deleteCompetitor = useCallback(
    (competitorId) => () => {
      if (confirm('Haluatko varmasti poistaa tämän kilpailijan?')) {
        del(`/official/limited/races/${race.id}/competitors/${competitorId}.json`, (err) => {
          if (err) {
            console.error('Error in deleting competitor', err)
          } else {
            setCompetitors((prev) => {
              const remaining = [...prev]
              const index = remaining.findIndex((c) => c.id === competitorId)
              remaining.splice(index, 1)
              return remaining
            })
          }
        })
      }
    },
    [race],
  )

  if (fetching || error) return <IncompletePage fetching={fetching} error={error} title={t('addCompetitor')} />

  const content = () => {
    if (!race.series.length) {
      return (
        <Message type="info">
          Tähän kilpailuun ei ole vielä lisätty yhtään sarjaa. Voit lisätä kilpailijoita vasta sen jälkeen, kun
          päätoimitsija on lisännyt kilpailuun sarjat.
        </Message>
      )
    }
    if (!race.clubs.length && !userRaceRight.newClubs) {
      return (
        <Message type="info">
          Tähän kilpailuun ei ole vielä lisätty yhtään piiriä tai seuraa. Voit lisätä kilpailijoita vasta sen jälkeen,
          kun päätoimitsija on lisännyt kilpailuun piirit/seurat.
        </Message>
      )
    }
    return <LimitedNewCompetitorForm race={race} initialCompetitor={initialCompetitor} onSave={onCreate} />
  }

  return (
    <div>
      <h2>{t('addCompetitor')}</h2>
      {content()}
      {competitors.length > 0 && (
        <CompetitorsList competitors={competitors} raceId={race.id} deleteCompetitor={deleteCompetitor} />
      )}
    </div>
  )
}

export default LimitedNewCompetitorPage
