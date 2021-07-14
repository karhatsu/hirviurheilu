import React, { useEffect } from 'react'
import useTitle from '../../util/useTitle'
import { useRace } from '../../util/useRace'
import RaceOrganizer from './RaceOrganizer'
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
import IncompletePage from '../../common/IncompletePage'

export default function RacePage({ setSelectedPage }) {
  const { t } = useTranslation()
  const { fetching, race, error } = useRace()
  useTitle(race?.name)
  useEffect(() => setSelectedPage(pages.raceHome), [setSelectedPage])

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
        <Button href="/" type="back">{t('backToHomePage')}</Button>
      </div>
    </>
  )
}
