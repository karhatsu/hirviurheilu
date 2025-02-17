import React from 'react'
import DesktopMenuItem from '../../public/menu/DesktopMenuItem'
import {
  buildOfficialRaceHeatsPath,
  buildOfficialRaceClubsPath,
  buildOfficialRaceCompetitorsPath,
  buildOfficialRaceCorrectDistancesPath,
  buildOfficialRaceCsvPath,
  buildOfficialRaceEditPath,
  buildOfficialRaceEuropeanPath,
  buildOfficialRaceFinalRoundHeatListPath,
  buildOfficialRaceNordicPath,
  buildOfficialRaceOfficialsPath,
  buildOfficialRacePath,
  buildOfficialRaceQualificationRoundHeatListPath,
  buildOfficialRaceQuickSavesPath,
  buildOfficialRaceRelaysPath,
  buildOfficialRaceShootingByHeatsPath,
  buildOfficialRaceStartListPath,
  buildOfficialRaceTeamCompetitionsPath,
  buildOfficialSeriesEstimatesPath,
  buildOfficialSeriesShotsPath,
  buildOfficialSeriesTimesPath,
} from '../../util/routeUtil'
import { useRace } from '../../util/useRace'
import useTranslation from '../../util/useTranslation'
import { resolveClubsTitle } from '../../util/clubUtil'
import useOfficialMenu from './useOfficialMenu'

const labels = {
  main: 'officialRaceMenuHome',
  edit: 'officialRaceMenuEdit',
  competitors: 'officialRaceMenuCompetitors',
  startList: 'officialRaceMenuStartList',
  heatListGeneration: 'officialRaceMenuHeatListGeneration',
  qualificationRound: 'officialRaceMenuQualificationRoundHeatList',
  finalRound: 'officialRaceMenuFinalRoundHeatList',
  heats: 'officialRaceMenuHeats',
  quickSaves: 'officialRaceMenuQuickSave',
  times: 'officialRaceMenuTimes',
  estimates: 'officialRaceMenuEstimates',
  shooting: 'officialRaceMenuShooting',
  shootingBySeries: 'officialRaceMenuShootingBySeries',
  shootingByHeats: 'officialRaceMenuShootingByHeats',
  nordicTrap: 'nordic_trap',
  nordicShotgun: 'nordic_shotgun',
  nordicRifleMoving: 'nordic_rifle_moving',
  nordicRifleStanding: 'nordic_rifle_standing',
  europeanTrap: 'european_trap',
  europeanCompak: 'european_compak',
  europeanRifle: 'european_rifle',
  correctDistances: 'officialRaceMenuCorrectDistances',
  csv: 'officialRaceMenuCsv',
  teamCompetitions: 'officialRaceMenuTeamCompetitions',
  relays: 'officialRaceMenuRelays',
  officials: 'officialRaceMenuOfficials',
}

const paths = {
  main: buildOfficialRacePath,
  edit: buildOfficialRaceEditPath,
  competitors: buildOfficialRaceCompetitorsPath,
  startList: buildOfficialRaceStartListPath,
  heatListGeneration: buildOfficialRaceQualificationRoundHeatListPath,
  qualificationRound: buildOfficialRaceQualificationRoundHeatListPath,
  finalRound: buildOfficialRaceFinalRoundHeatListPath,
  heats: buildOfficialRaceHeatsPath,
  quickSaves: buildOfficialRaceQuickSavesPath,
  times: buildOfficialSeriesTimesPath,
  estimates: buildOfficialSeriesEstimatesPath,
  shooting: buildOfficialSeriesShotsPath,
  shootingBySeries: buildOfficialSeriesShotsPath,
  shootingByHeats: buildOfficialRaceShootingByHeatsPath,
  nordicTrap: raceId => buildOfficialRaceNordicPath(raceId, 'trap'),
  nordicShotgun: raceId => buildOfficialRaceNordicPath(raceId, 'shotgun'),
  nordicRifleMoving: raceId => buildOfficialRaceNordicPath(raceId, 'rifle_moving'),
  nordicRifleStanding: raceId => buildOfficialRaceNordicPath(raceId, 'rifle_standing'),
  europeanTrap: raceId => buildOfficialRaceEuropeanPath(raceId, 'trap'),
  europeanCompak: raceId => buildOfficialRaceEuropeanPath(raceId, 'compak'),
  europeanRifle: raceId => buildOfficialRaceEuropeanPath(raceId, 'rifle'),
  csv: buildOfficialRaceCsvPath,
  correctDistances: buildOfficialRaceCorrectDistancesPath,
  teamCompetitions: buildOfficialRaceTeamCompetitionsPath,
  relays: buildOfficialRaceRelaysPath,
  clubs: buildOfficialRaceClubsPath,
  officials: buildOfficialRaceOfficialsPath,
}

const reactPages = ['clubs', 'officials']

const useSeries = {
  competitors: true,
  heatListGeneration: true,
  qualificationRound: true,
  finalRound: true,
  times: true,
  estimates: true,
  shooting: true,
  shootingBySeries: true,
}

const requireSeries = {
  quickSaves: true,
  shootingByHeats: true,
  csv: true,
  teamCompetitions: true,
}

const nordicKeys = [
  'main',
  'edit',
  'competitors',
  'heatListGeneration',
  'heats',
  'nordicTrap',
  'nordicShotgun',
  'nordicRifleMoving',
  'nordicRifleStanding',
  'csv',
  'teamCompetitions',
  'clubs',
  'officials',
]

const europeanKeys = [
  'main',
  'edit',
  'competitors',
  'heatListGeneration',
  'heats',
  'europeanTrap',
  'europeanCompak',
  'europeanRifle',
  'csv',
  'teamCompetitions',
  'clubs',
  'officials',
]

const shootingKeys = [
  'main',
  'edit',
  'competitors',
  'qualificationRound',
  'finalRound',
  'heats',
  'quickSaves',
  'shootingBySeries',
  'shootingByHeats',
  'csv',
  'teamCompetitions',
  'clubs',
  'officials',
]

const threeSportsKeys = [
  'main',
  'edit',
  'competitors',
  'startList',
  'quickSaves',
  'times',
  'estimates',
  'shooting',
  'correctDistances',
  'csv',
  'teamCompetitions',
  'relays',
  'clubs',
  'officials',
]

const resolveMenuItems = race => {
  if (race.sport.nordic) return nordicKeys
  else if (race.sport.european) return europeanKeys
  else if (race.sport.shooting) return shootingKeys
  else return threeSportsKeys
}

const buildMenuItem = (selectedPage, key, t, race, series) => {
  if ((useSeries[key] || requireSeries[key]) && !series) return
  const text = key === 'clubs' ? resolveClubsTitle(t, race.clubLevel) : t(labels[key])
  return (
    <DesktopMenuItem
      key={key}
      path={paths[key](useSeries[key] ? series.id : race.id)}
      text={text}
      reactLink={reactPages.includes(key)}
      selected={key === selectedPage}
      dropdownItems={useSeries[key] && race.series.map(s => {
        return { text: s.name, path: paths[key](s.id) }
      })}
    />
  )
}

const RaceSecondLevelMenu = ({ visible }) => {
  const { t } = useTranslation()
  const { race } = useRace()
  const { selectedPage } = useOfficialMenu()
  if (!race) return null
  const series = race.series[0]
  return (
    <div className={`menu menu--sub menu--sub-1 ${visible ? 'menu--visible' : ''}`}>
      {resolveMenuItems(race).map(key => buildMenuItem(selectedPage, key, t, race, series))}
    </div>
  )
}

export default RaceSecondLevelMenu
