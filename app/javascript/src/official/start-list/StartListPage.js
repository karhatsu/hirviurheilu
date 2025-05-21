import useOfficialMenu from '../menu/useOfficialMenu'
import { useCallback, useEffect, useMemo } from 'react'
import { useRace } from '../../util/useRace'
import useTranslation from '../../util/useTranslation'
import useTitle from '../../util/useTitle'
import IncompletePage from '../../common/IncompletePage'
import Button from '../../common/Button'
import { buildOfficialRacePath, buildRaceStartListsPdfPath } from '../../util/routeUtil'
import useOfficialRaceCompetitors from '../results/useOfficialRaceCompetitors'
import CompetitorRow from './CompetitorRow'
import Message from '../../common/Message'

const titleKey = 'officialRaceMenuStartList'

const StartListPage = () => {
  const { t } = useTranslation()
  const { race, error, fetching, setRace } = useRace()
  const { setSelectedPage } = useOfficialMenu()
  const { competitors: unsortedCompetitors, setCompetitors } = useOfficialRaceCompetitors()

  useEffect(() => setSelectedPage('startList'), [setSelectedPage])
  useTitle(race && `${t(titleKey)} - ${race.name}`)

  const availableSeries = useMemo(() => {
    return race?.series.filter((s) => s.hasStartList) || []
  }, [race])

  const competitors = useMemo(() => {
    const seriesIds = availableSeries.map((s) => s.id)
    return unsortedCompetitors?.filter((c) => seriesIds.includes(c.seriesId)).sort((a, b) => a.number - b.number)
  }, [availableSeries, unsortedCompetitors])

  const ensureClubExists = useCallback(
    (clubId, clubName) => {
      if (race && !race.clubs.find((c) => c.id === clubId)) {
        setRace((prev) => {
          const newRace = { ...prev, clubs: [...prev.clubs] }
          newRace.clubs.push({ id: clubId, name: clubName })
          newRace.clubs.sort((a, b) => a.name.localeCompare(b.name))
          return newRace
        })
      }
    },
    [race, setRace],
  )

  const onCreate = useCallback(
    (competitor, clubName) => {
      setCompetitors((prev) => [...prev, competitor])
      ensureClubExists(competitor.clubId, clubName)
    },
    [setCompetitors, ensureClubExists],
  )

  const onUpdate = useCallback(
    (competitor, clubName) => {
      setCompetitors((prev) => {
        const competitors = [...prev]
        const index = competitors.findIndex((c) => c.id === competitor.id)
        competitors[index] = { ...competitors[index], ...competitor }
        return competitors
      })
      ensureClubExists(competitor.clubId, clubName)
    },
    [setCompetitors, ensureClubExists],
  )

  if (!race || !competitors) {
    return <IncompletePage title={t(titleKey)} error={error} fetching={fetching} />
  }

  const newCompetitor = {
    number: race.nextNumber,
    startTime: race.nextStartTime,
    firstName: '',
    lastName: '',
    seriesId: availableSeries[0]?.id,
    ageGroupId: '',
  }

  const content = () => {
    if (!availableSeries.length) {
      return <Message type="info">{t('noStartListForAnySeries')}</Message>
    }
    return (
      <>
        <CompetitorRow race={race} availableSeries={availableSeries} competitor={newCompetitor} onSave={onCreate} />
        <hr />
        {competitors.map((competitor) => (
          <CompetitorRow
            key={competitor.id}
            availableSeries={availableSeries}
            race={race}
            competitor={competitor}
            onSave={onUpdate}
          />
        ))}
      </>
    )
  }

  return (
    <div>
      <h2>{t(titleKey)}</h2>
      {content()}
      <div className="buttons buttons--nav">
        <Button href={buildOfficialRacePath(race.id)} type="back">
          {t('backToOfficialRacePage')}
        </Button>
        {availableSeries.length > 0 && (
          <Button type="pdf" href={buildRaceStartListsPdfPath(race.id)}>
            {t('downloadStartListPdf')}
          </Button>
        )}
      </div>
    </div>
  )
}

export default StartListPage
