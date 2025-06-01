import DesktopMenuItem from '../../public/menu/DesktopMenuItem'
import { buildLimitedOfficialCompetitorsPath, buildLimitedOfficialAddManyCompetitorsPath } from '../../util/routeUtil'
import useTranslation from '../../util/useTranslation'
import useOfficialMenu from './useOfficialMenu'
import { useRace } from '../../util/useRace'

const labels = {
  competitors: 'officialRaceMenuCompetitors',
  addManyCompetitors: 'officialRaceMenuAddManyCompetitors',
}

const paths = {
  competitors: buildLimitedOfficialCompetitorsPath,
  addManyCompetitors: buildLimitedOfficialAddManyCompetitorsPath,
}

const reactPages = ['competitors']

const menuItems = ['competitors', 'addManyCompetitors']

const buildMenuItem = (selectedPage, key, t, race) => {
  const text = t(labels[key])

  return (
    <DesktopMenuItem
      key={key}
      path={paths[key](race.id)}
      text={text}
      reactLink={reactPages.includes(key)}
      selected={key === selectedPage}
    />
  )
}

const LimitedRaceSecondLevelMenu = ({ visible }) => {
  const { t } = useTranslation()
  const { race } = useRace()
  const { selectedPage } = useOfficialMenu()
  if (!race) return null
  return (
    <div className={`menu menu--sub menu--sub-1 ${visible ? 'menu--visible' : ''}`}>
      {menuItems.map((key) => buildMenuItem(selectedPage, key, t, race))}
    </div>
  )
}

export default LimitedRaceSecondLevelMenu
