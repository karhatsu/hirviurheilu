import React from 'react'
import useTitle from '../../util/useTitle'
import { useRace } from '../../util/useRace'
import RaceOrganizer from './RaceOrganizer'
import Spinner from '../../spinner/Spinner'
import RacePublicMessage from './RacePublicMessage'
import useTranslation from '../../util/useTranslation'
import RaceBatches from './RaceBatches'
import RaceSeries from './RaceSeries'
import RaceCups from './RaceCups'
import RaceCorrectDistances from './RaceCorrectDistances'
import RaceResultsPdf from './RaceResultsPdf'
import RaceRelays from './RaceRelays'
import RaceTeamCompetitions from './RaceTeamCompetitions'

export default function RacePage() {
  const { t } = useTranslation()
  const { race, error } = useRace()
  useTitle(race?.name)

  if (error) return <div className="message message--error">{error}</div>
  if (!race && !error) return <Spinner />

  const { cancelled } = race
  return (
    <>
      <RaceOrganizer race={race} />
      <RacePublicMessage race={race} />
      {cancelled && (
        <>
          <h2>{t('raceCancelledTitle')}</h2>
          <div className="message message--error">{t('raceCancelledMessage')}</div>
        </>
      )}
      {!cancelled && (
        <>
          <RaceBatches race={race} />
          <RaceSeries race={race} />
          <RaceCorrectDistances race={race} />
          <RaceTeamCompetitions race={race} />
          <RaceRelays race={race} />
          <RaceResultsPdf race={race} />
          <RaceCups race={race} />
        </>
      )}
      <div className="buttons buttons--nav">
        <a href="/app/assets/config" className="button button--back">{t('backToHomePage')}</a>
      </div>
    </>
  )
}
