import React, { useEffect } from 'react'
import useTitle from '../../util/useTitle'
import { useRace } from '../../util/useRace'
import RaceOrganizer from './RaceOrganizer'
import Spinner from '../../common/Spinner'
import RacePublicMessage from './RacePublicMessage'
import useTranslation from '../../util/useTranslation'
import RaceBatches from './RaceBatches'
import RaceSeries from './RaceSeries'
import RaceCups from './RaceCups'
import RaceCorrectDistances from './RaceCorrectDistances'
import RaceResultsPdf from './RaceResultsPdf'
import RaceRelays from './RaceRelays'
import RaceTeamCompetitions from './RaceTeamCompetitions'
import { pages } from '../menu/DesktopSecondLevelMenu'
import Button from '../../common/Button'
import Message from '../../common/Message'

export default function RacePage({ setSelectedPage }) {
  const { t } = useTranslation()
  const { race, error } = useRace()
  useTitle(race?.name)
  useEffect(() => setSelectedPage(pages.raceHome), [setSelectedPage])

  if (error) return <Message type="error">{error}</Message>
  if (!race && !error) return <Spinner />

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
        <Button href="/app/assets/config" type="back">{t('backToHomePage')}</Button>
      </div>
    </>
  )
}
