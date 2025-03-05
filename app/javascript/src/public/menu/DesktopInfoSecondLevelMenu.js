import DesktopMenuItem from './DesktopMenuItem'
import {
  buildAnswersPath,
  buildFeedbackPath,
  buildInfoPath,
  buildPricesPath,
  buildSportsInfoPath,
} from '../../util/routeUtil'
import useTranslation from '../../util/useTranslation'
import useMenu, { pages } from '../../util/useMenu'

export default function DesktopInfoSecondLevelMenu() {
  const { t } = useTranslation()
  const { selectedPage } = useMenu()
  return (
    <div className="menu menu--sub menu--sub-1">
      <DesktopMenuItem
        path={buildInfoPath()}
        text={t('info')}
        selected={selectedPage === pages.info.main}
        reactLink={true}
      />
      <DesktopMenuItem
        path={buildAnswersPath()}
        text={t('answersTitle')}
        selected={selectedPage === pages.info.answers}
        reactLink={true}
      />
      <DesktopMenuItem
        path={buildPricesPath()}
        text={t('prices')}
        selected={selectedPage === pages.info.prices}
        reactLink={true}
      />
      <DesktopMenuItem
        path={buildFeedbackPath()}
        text={t('sendFeedback')}
        selected={selectedPage === pages.info.feedback}
        reactLink={true}
      />
      <DesktopMenuItem
        path={buildSportsInfoPath()}
        text={t('sportsInfo')}
        selected={selectedPage === pages.info.sportsInfo}
        reactLink={true}
      />
    </div>
  )
}
