import useOfficialMenu from "../menu/useOfficialMenu"
import { useRace } from "../../util/useRace"
import { useEffect } from "react"
import useTranslation from "../../util/useTranslation"
import useOfficialSeries from "./useOfficialSeries"
import IncompletePage from "../../common/IncompletePage"
import ResultPage from "./ResultPage"
import ThreeSportsShootingForm from "./ThreeSportsShootingForm"
import ShootingRaceShootingForm from "./ShootingRaceShootingForm"
import Message from "../../common/Message"
import { useSearchParams } from "react-router"
import Button from "../../common/Button"

const titleKey = 'officialRaceMenuShooting'

const CompetitorForm = ({ competitor, sport }) => {
  if (sport.qualificationRound) {
    return <ShootingRaceShootingForm competitor={competitor} sport={sport} />
  }
  return <ThreeSportsShootingForm competitor={competitor} />
}

const ShotsPage = () => {
  const {t} = useTranslation()
  const {setSelectedPage} = useOfficialMenu()
  const {race} = useRace()
  const {error, fetching, series} = useOfficialSeries()
  const [searchParams] = useSearchParams()

  useEffect(() => {
    if (race?.sport.heatList) setSelectedPage('shootingBySeries')
    else setSelectedPage('shooting')
  }, [race?.sport, setSelectedPage])

  if (!race || !series) return <IncompletePage title={t(titleKey)} error={error} fetching={fetching}/>

  const renderAboveCompetitors = () => {
    const qr = searchParams.get('qualification_round') === 'true'
    return (
      <>
        <Message type="info">{t('eitherTotalScoreOrShots')}</Message>
        {race?.sport.qualificationRound && (
          <Button href={qr ? '?' : '?qualification_round=true'}>
            {t(qr ? 'shotsPageSortByNumber' : 'shotsPageSortByQR')}
          </Button>
        )}
      </>
    )
  }

  return (
    <ResultPage race={race} series={series} titleKey={titleKey} renderAboveCompetitors={renderAboveCompetitors}>
      {competitor => <CompetitorForm competitor={competitor} sport={race.sport}/>}
    </ResultPage>
  )
}

export default ShotsPage
