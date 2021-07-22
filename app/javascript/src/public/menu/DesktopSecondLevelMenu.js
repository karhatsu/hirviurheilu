import React from 'react'
import { useRace } from '../../util/useRace'
import DesktopMenuItem from './DesktopMenuItem'
import useTranslation from '../../util/useTranslation'
import { useParams } from 'react-router-dom'
import {
  buildFinalRoundBatchesPath,
  buildNordicResultsPath,
  buildQualificationRoundBatchesPath,
  buildRacePath,
  buildRelayPath,
  buildRifleTeamCompetitionsPath,
  buildSeriesResultsPath,
  buildSeriesRifleResultsPath,
  buildSeriesStartListPath,
  buildTeamCompetitionsPath,
} from '../../util/routeUtil'
import { useResultRotation } from '../result-rotation/useResultRotation'

export const pages = {
  raceHome: 0,
  results: 1,
  startList: 2,
  nordic: {
    trap: 3,
    shotgun: 4,
    rifle_standing: 5,
    rifle_moving: 6,
  },
  europeanRifle: 7,
  teamCompetitions: 8,
  rifleTeamCompetitions: 9,
  relays: 10,
  media: 11,
  batches: {
    qualificationRound: 12,
    finalRound: 13,
  },
  resultRotation: 14,
}

export default function DesktopSecondLevelMenu({ selectedPage }) {
  const { seriesId: urlSeriesId } = useParams()
  const { t } = useTranslation()
  const { race } = useRace()
  const { started: resultRotationStarted } = useResultRotation()
  if (!race || race.cancelled) return null
  const seriesId = urlSeriesId || (race.series.length > 0 && race.series[0].id)
  return (
    <div className="menu menu--sub menu--sub-1">
      <DesktopMenuItem
        path={buildRacePath(race.id)}
        text={t('raceMenuHome')}
        reactLink={true}
        selected={selectedPage === pages.raceHome}
      />
      {seriesId && (
        <>
          <DesktopMenuItem
            path={buildSeriesResultsPath(race.id, seriesId)}
            text={t('results')}
            selected={selectedPage === pages.results}
            reactLink={true}
            dropdownItems={race.series.map(s => {
              return { text: s.name, path: buildSeriesResultsPath(race.id, s.id), reactLink: true }
            })}
          />
          {race.sport.nordic && (
            <>
              {['trap', 'shotgun', 'rifle_moving', 'rifle_standing'].map(subSport => {
                return (
                  <DesktopMenuItem
                    key={subSport}
                    path={buildNordicResultsPath(race.id, subSport)}
                    text={t(`nordic_${subSport}`)}
                    selected={selectedPage === pages.nordic[subSport]}
                    reactLink={true}
                  />
                )
              })}
            </>
          )}
          {race.sport.european && (
            <DesktopMenuItem
              path={buildSeriesRifleResultsPath(race.id, seriesId)}
              text={t('rifle')}
              selected={selectedPage === pages.europeanRifle}
              reactLink={true}
              dropdownItems={race.series.map(s => (
                { text: s.name, path: buildSeriesRifleResultsPath(race.id, s.id), reactLink: true }),
              )}
            />
          )}
          {race.sport.batchList && race.qualificationRoundBatches.length > 0 && (
            <DesktopMenuItem
              path={buildQualificationRoundBatchesPath(race.id)}
              text={t(race.sport.oneBatchList ? 'batchList' : 'qualificationRoundBatchList')}
              selected={selectedPage === pages.batches.qualificationRound}
              reactLink={true}
            />
          )}
          {race.sport.batchList && race.finalRoundBatches.length > 0 && (
            <DesktopMenuItem
              path={buildFinalRoundBatchesPath(race.id)}
              text={t('finalRoundBatchList')}
              selected={selectedPage === pages.batches.finalRound}
              reactLink={true}
            />
          )}
          {race.sport.startList && (
            <DesktopMenuItem
              path={buildSeriesStartListPath(race.id, seriesId)}
              text={t('startLists')}
              selected={selectedPage === pages.startList}
              reactLink={true}
              dropdownItems={race.series.map(s => {
                return { text: s.name, path: buildSeriesStartListPath(race.id, s.id), reactLink: true }
              })}
            />
          )}
        </>
      )}
      {race.teamCompetitions.length > 0 && (
        <DesktopMenuItem
          path={buildTeamCompetitionsPath(race.id, race.teamCompetitions[0].id)}
          text={t(race.teamCompetitions.length > 1 ? 'teamCompetitions' : 'teamCompetition')}
          selected={selectedPage === pages.teamCompetitions}
          reactLink={true}
          dropdownItems={race.teamCompetitions.map(tc => {
            return { text: tc.name, path: buildTeamCompetitionsPath(race.id, tc.id), reactLink: true }
          })}
        />
      )}
      {race.sport.european && race.teamCompetitions.length > 0 && (
        <DesktopMenuItem
          path={buildRifleTeamCompetitionsPath(race.id, race.teamCompetitions[0].id)}
          text={t(race.teamCompetitions.length > 1 ? 'rifleTeamCompetitions' : 'rifleTeamCompetition')}
          selected={selectedPage === pages.rifleTeamCompetitions}
          reactLink={true}
          dropdownItems={race.teamCompetitions.map(tc => {
            return { text: tc.name, path: buildRifleTeamCompetitionsPath(race.id, tc.id) }
          })}
        />
      )}
      {race.relays.length > 0 && (
        <DesktopMenuItem
          path={buildRelayPath(race.id, race.relays[0].id)}
          text={t(race.relays.length > 1 ? 'relays' : 'relay')}
          selected={selectedPage === pages.relays}
          reactLink={true}
          dropdownItems={race.relays.map(r => ({ text: r.name, path: buildRelayPath(race.id, r.id) }))}
        />
      )}
      {race.series.length > 0 && (
        <DesktopMenuItem
          path={`/races/${race.id}/result_rotation`}
          text={t('resultRotation')}
          selected={selectedPage === pages.resultRotation || resultRotationStarted}
          reactLink={true}
        />
      )}
      {race.series.length > 0 && (
        <DesktopMenuItem
          path={`/races/${race.id}/medium/new`}
          text={t('press')}
          selected={selectedPage === pages.media}
          reactLink={true}
        />
      )}
    </div>
  )
}
