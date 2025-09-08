import useOfficialMenu from '../menu/useOfficialMenu'
import { useEffect } from 'react'
import useTranslation from '../../util/useTranslation'
import useTitle from '../../util/useTitle'
import { useRace } from '../../util/useRace'
import useOfficialRaceCompetitors from '../results/useOfficialRaceCompetitors'
import IncompletePage from '../../common/IncompletePage'
import Message from '../../common/Message'
import Button from '../../common/Button'
import { buildOfficialRacePath } from '../../util/routeUtil'
import ResultSection from './ResultSection'

const titleKey = 'quickSaves'

const QuickSavesPage = () => {
  const { t } = useTranslation()
  const { setSelectedPage } = useOfficialMenu()
  const { race, fetching } = useRace()
  const { competitors } = useOfficialRaceCompetitors()

  useEffect(() => setSelectedPage('quickSaves'), [setSelectedPage])
  useTitle(race && `${t(titleKey)} - ${race.name}`)

  if (fetching || !competitors) return <IncompletePage title={t(titleKey)} fetching={true} />

  const content = () => {
    if (!competitors.length) return <Message type="info">{t('noCompetitorsInRace')}</Message>
    if (race.sport.shooting) {
      const instructionsKey =
        race.sportKey === 'ILMALUODIKKO' ? 'ilmaluodikko' : race.sport.bestShotValue === 1 ? 'shotgun' : 'other'
      return (
        <div>
          <ResultSection
            raceId={race.id}
            titleKey="qualificationRound"
            instructionsKey={`quickSavesHelpShotsQR_${instructionsKey}`}
            field="qualification_round_shots"
            path="qualification_round_shots_quick_save"
          />
          <ResultSection
            raceId={race.id}
            titleKey="finalRound"
            instructionsKey={`quickSavesHelpShotsFR_${instructionsKey}`}
            field="final_round_shots"
            path="final_round_shots_quick_save"
          />
          <ResultSection
            raceId={race.id}
            titleKey="extraShots"
            instructionsKey={`quickSavesHelpShotsExtra_${instructionsKey}`}
            field="extra_shots"
            path="extra_shots_quick_save"
          />
        </div>
      )
    }
    return (
      <div>
        <ResultSection
          raceId={race.id}
          titleKey="officialRaceMenuTimes"
          instructionsKey="quickSavesHelpTimes"
          field="time"
          path="time_quick_save"
        />
        <ResultSection
          raceId={race.id}
          titleKey="officialRaceMenuEstimates"
          instructionsKey={race.estimatesAtMost === 4 ? 'quickSavesHelpEstimates4' : 'quickSavesHelpEstimates'}
          field="estimates"
          path="estimates_quick_save"
        />
        <ResultSection
          raceId={race.id}
          titleKey="officialRaceMenuShooting"
          instructionsKey="quickSavesHelpShots"
          field="shots"
          path="shots_quick_save"
        />
        <ResultSection
          raceId={race.id}
          titleKey="quickSavesNoResult"
          instructionsKey="quickSavesHelpNoResult"
          path="no_result_quick_save"
        />
      </div>
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
      </div>
    </div>
  )
}

export default QuickSavesPage
