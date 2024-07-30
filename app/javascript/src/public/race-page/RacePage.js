import React, { useEffect } from 'react'
import useTitle from '../../util/useTitle'
import { useRace } from '../../util/useRace'
import RaceOrganizer from './RaceOrganizer'
import RacePublicMessage from './RacePublicMessage'
import useTranslation from '../../util/useTranslation'
import RaceHeats from './RaceHeats'
import RaceSeries from './RaceSeries'
import RaceCups from './RaceCups'
import RaceCorrectDistances from './RaceCorrectDistances'
import RaceResultsPdf from './RaceResultsPdf'
import RaceRelays from './RaceRelays'
import RaceTeamCompetitions from './RaceTeamCompetitions'
import useMenu, { pages } from '../../util/useMenu'
import Button from '../../common/Button'
import Message from '../../common/Message'
import IncompletePage from '../../common/IncompletePage'
import { buildRootPath } from '../../util/routeUtil'

const msToStart = start => start ? new Date(start).getTime() - new Date().getTime() : Number.MAX_SAFE_INTEGER

const findFirstNotStarted = seriesOrRelays => seriesOrRelays.sort((a, b) => {
  return a.startTime?.localeCompare(b.startTime)
}).find(s => s.startTime && !s.started)

export default function RacePage() {
  const { t } = useTranslation()
  const { setSelectedPage } = useMenu(pages.raceHome)
  const { fetching, race, error, reload: reloadRace } = useRace()
  useTitle(race && [race.name, t(`sport_${race.sportKey}`)], race)
  useEffect(() => setSelectedPage(pages.raceHome), [setSelectedPage])

  useEffect(() => {
    if (race) {
      const nextSeries = findFirstNotStarted(race.series)
      const nextRelay = findFirstNotStarted(race.relays)
      if (nextSeries || nextRelay) {
        const msToSeriesStart = msToStart(nextSeries?.startTime)
        const msToRelayStart = msToStart(nextRelay?.startTime)
        const ms = Math.max(0, Math.min(msToSeriesStart, msToRelayStart))
        const timeout = setTimeout(() => {
          reloadRace()
        }, ms + 5000 * Math.random())
        return () => clearTimeout(timeout)
      }
    }
  }, [race, reloadRace])

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} />
  }

  const { cancelled } = race
  return (
    <>
      <RaceOrganizer race={race} />
      <RacePublicMessage race={race} />
      {cancelled && (
        <>
          <h2>{t('raceCancelledTitle')}</h2>
          <Message type="error">{t('raceCancelledMessage')}</Message>
        </>
      )}
      {!cancelled && (
        <>
          <RaceHeats race={race} />
          <RaceSeries race={race} />
          <RaceCorrectDistances race={race} />
          <RaceTeamCompetitions race={race} />
          <RaceRelays race={race} />
          <RaceResultsPdf race={race} />
          <RaceCups race={race} />
        </>
      )}
      <div className="buttons buttons--nav">
        <Button to={buildRootPath()} type="back">{t('backToHomePage')}</Button>
      </div>
    </>
  )
}
