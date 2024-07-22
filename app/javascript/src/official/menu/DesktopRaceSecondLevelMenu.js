import React from 'react'
import DesktopMenuItem from '../../public/menu/DesktopMenuItem'
import {
  buildOfficialRaceBatchesPath,
  buildOfficialRaceClubsPath,
  buildOfficialRaceCompetitorsPath,
  buildOfficialRaceCorrectDistancesPath,
  buildOfficialRaceCsvPath,
  buildOfficialRaceEditPath,
  buildOfficialRaceEuropeanPath,
  buildOfficialRaceFinalRoundBatchListPath,
  buildOfficialRaceNordicPath,
  buildOfficialRaceOfficialsPath,
  buildOfficialRacePath,
  buildOfficialRaceQualificationRoundBatchListPath,
  buildOfficialRaceQuickSavesPath,
  buildOfficialRaceRelaysPath,
  buildOfficialRaceShootingByBatchesPath,
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
  batchListGeneration: 'officialRaceMenuBatchListGeneration',
  qualificationRound: 'officialRaceMenuQualificationRoundBatchList',
  finalRound: 'officialRaceMenuFinalRoundBatchList',
  batches: 'officialRaceMenuBatches',
  quickSaves: 'officialRaceMenuQuickSave',
  times: 'officialRaceMenuTimes',
  estimates: 'officialRaceMenuEstimates',
  shooting: 'officialRaceMenuShooting',
  shootingBySeries: 'officialRaceMenuShootingBySeries',
  shootingByBatches: 'officialRaceMenuShootingByBatches',
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
  batchListGeneration: buildOfficialRaceQualificationRoundBatchListPath,
  qualificationRound: buildOfficialRaceQualificationRoundBatchListPath,
  finalRound: buildOfficialRaceFinalRoundBatchListPath,
  batches: buildOfficialRaceBatchesPath,
  quickSaves: buildOfficialRaceQuickSavesPath,
  times: buildOfficialSeriesTimesPath,
  estimates: buildOfficialSeriesEstimatesPath,
  shooting: buildOfficialSeriesShotsPath,
  shootingBySeries: buildOfficialSeriesShotsPath,
  shootingByBatches: buildOfficialRaceShootingByBatchesPath,
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
  batchListGeneration: true,
  qualificationRound: true,
  finalRound: true,
  times: true,
  estimates: true,
  shooting: true,
  shootingBySeries: true,
}

const requireSeries = {
  quickSaves: true,
  shootingByBatches: true,
  csv: true,
  teamCompetitions: true,
}

const nordicKeys = [
  'main',
  'edit',
  'competitors',
  'batchListGeneration',
  'batches',
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
  'batchListGeneration',
  'batches',
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
  'batches',
  'quickSaves',
  'shootingBySeries',
  'shootingByBatches',
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

const DesktopRaceSecondLevelMenu = ({ visible }) => {
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

export default DesktopRaceSecondLevelMenu
