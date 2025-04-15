import useOfficialMenu from "../menu/useOfficialMenu"
import { useRace } from "../../util/useRace"
import { useEffect } from "react"
import useTranslation from "../../util/useTranslation"
import useOfficialSeries from "./useOfficialSeries"
import IncompletePage from "../../common/IncompletePage"
import ResultPage from "./ResultPage"
import ThreeSportsShootingForm from "./ThreeSportsShootingForm"

const titleKey = 'officialRaceMenuShooting'

const CompetitorForm = ({ competitor }) => {
  return <ThreeSportsShootingForm competitor={competitor} />
}

const ShotsPage = () => {
  const {t} = useTranslation()
  const {setSelectedPage} = useOfficialMenu()
  const {race} = useRace()
  const {error, fetching, series} = useOfficialSeries()

  useEffect(() => setSelectedPage('shooting'), [setSelectedPage])

  if (!race || !series) return <IncompletePage title={t(titleKey)} error={error} fetching={fetching}/>

  return (
    <ResultPage race={race} series={series} titleKey={titleKey}>
      {competitor => <CompetitorForm competitor={competitor}/>}
    </ResultPage>
  )
}

export default ShotsPage
