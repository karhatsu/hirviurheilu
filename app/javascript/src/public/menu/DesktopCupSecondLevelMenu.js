import DesktopMenuItem from './DesktopMenuItem'
import {
  buildCupPressPath,
  buildCupPath,
  buildCupSeriesPath, buildCupTeamCompetitionsPath,
  buildRifleCupSeriesPath,
} from '../../util/routeUtil'
import useMenu, { pages } from '../../util/useMenu'
import useTranslation from '../../util/useTranslation'

export default function DesktopCupSecondLevelMenu({ cup }) {
  const { t } = useTranslation()
  const { selectedPage } = useMenu()
  const cupSeriesId = cup.cupSeries.length > 0 && cup.cupSeries[0].id
  const cupTeamCompetitionId = cup.cupTeamCompetitions.length > 0 && cup.cupTeamCompetitions[0].id
  return (
    <div className="menu menu--sub menu--sub-1">
      <DesktopMenuItem
        path={buildCupPath(cup.id)}
        text={t('cupHome')}
        selected={selectedPage === pages.cup.home}
        reactLink={true}
      />
      {cupSeriesId && (
        <>
          <DesktopMenuItem
            path={buildCupSeriesPath(cup.id, cupSeriesId)}
            text={t('results')}
            selected={selectedPage === pages.cup.results}
            reactLink={true}
            dropdownItems={cup.cupSeries.map(cs => {
              return { text: cs.name, path: buildCupSeriesPath(cup.id, cs.id), reactLink: true }
            })}
          />
          {cup.hasRifle && (
            <DesktopMenuItem
              path={buildRifleCupSeriesPath(cup.id, cupSeriesId)}
              text={t('rifle')}
              selected={selectedPage === pages.cup.rifleResults}
              reactLink={true}
              dropdownItems={cup.cupSeries.map(cs => {
                return { text: cs.name, path: buildRifleCupSeriesPath(cup.id, cs.id), reactLink: true }
              })}
            />
          )}
        </>
      )}
      {cupTeamCompetitionId && (
        <DesktopMenuItem
          path={buildCupTeamCompetitionsPath(cup.id, cupTeamCompetitionId)}
          text={t('teamCompetitions')}
          selected={selectedPage === pages.cup.teamCompetitions}
          reactLink={true}
          dropdownItems={cup.cupTeamCompetitions.map(ctc => {
            return { text: ctc.name, path: buildCupTeamCompetitionsPath(cup.id, ctc.id), reactLink: true }
          })}
        />
      )}
      {cupSeriesId && (
        <DesktopMenuItem
          path={buildCupPressPath(cup.id)}
          text={t('press')}
          selected={selectedPage === pages.cup.press}
          reactLink={true}
        />
      )}
    </div>
  )
}
