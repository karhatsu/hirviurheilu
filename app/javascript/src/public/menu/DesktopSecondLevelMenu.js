import React from 'react'
import { useRace } from '../../util/useRace'
import DesktopMenuItem from './DesktopMenuItem'
import useTranslation from '../../util/useTranslation'
import { useParams, useRouteMatch } from 'react-router-dom'
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

export default function DesktopSecondLevelMenu() {
  const { seriesId: urlSeriesId } = useParams()
  const isHomePage = useRouteMatch({ path: '/:lang?/races/:raceId', strict: true }) && !urlSeriesId
  const { t } = useTranslation()
  const { race } = useRace()
  if (!race || race.cancelled) return null
  const seriesId = urlSeriesId || (race.series.length > 0 && race.series[0].id)
  return (
    <div className="menu menu--sub menu--sub-1">
      <DesktopMenuItem
        path={buildRacePath(race.id)}
        text={t('raceMenuHome')}
        reactLink={true}
        selected={isHomePage}
      />
      {seriesId && (
        <>
          <DesktopMenuItem
            path={buildSeriesResultsPath(race.id, seriesId)}
            text={t('results')}
            dropdownItems={race.series.map(s => ({ text: s.name, path: buildSeriesResultsPath(race.id, s.id) }))}
          />
          {race.sport.nordic && (
            <>
              {['trap', 'shotgun', 'rifle_standing', 'rifle_moving'].map(subSport => {
                return (
                  <DesktopMenuItem
                    key={subSport}
                    path={buildNordicResultsPath(race.id, subSport)}
                    text={t(`nordic_${subSport}`)}
                  />
                )
              })}
            </>
          )}
          {race.sport.european && (
            <DesktopMenuItem
              path={buildSeriesRifleResultsPath(race.id, seriesId)}
              text={t('rifle')}
              dropdownItems={race.series.map(s => ({ text: s.name, path: buildSeriesRifleResultsPath(race.id, s.id) }))}
            />
          )}
          {race.sport.batchList && race.qualificationRoundBatches.length > 0 && (
            <DesktopMenuItem
              path={buildQualificationRoundBatchesPath(race.id)}
              text={t(race.sport.oneBatchList ? 'batchLists' : 'qualificationRoundBatchLists')}
            />
          )}
          {race.sport.batchList && race.finalRoundBatches.length > 0 && (
            <DesktopMenuItem
              path={buildFinalRoundBatchesPath(race.id)}
              text={t('finalRoundBatchLists')}
            />
          )}
          {race.sport.startList && (
            <DesktopMenuItem
              path={buildSeriesStartListPath(race.id, seriesId)}
              text={t('startLists')}
              routeMatch="/:lang?/races/:raceId/series/:seriesId/start_list"
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
          dropdownItems={race.teamCompetitions.map(tc => {
            return { text: tc.name, path: buildTeamCompetitionsPath(race.id, tc.id) }
          })}
        />
      )}
      {race.sport.european && race.teamCompetitions.length > 0 && (
        <DesktopMenuItem
          path={buildRifleTeamCompetitionsPath(race.id, race.teamCompetitions[0].id)}
          text={t(race.teamCompetitions.length > 1 ? 'rifleTeamCompetitions' : 'rifleTeamCompetition')}
          dropdownItems={race.teamCompetitions.map(tc => {
            return { text: tc.name, path: buildRifleTeamCompetitionsPath(race.id, tc.id) }
          })}
        />
      )}
      {race.relays.length > 0 && (
        <DesktopMenuItem
          path={buildRelayPath(race.id, race.relays[0].id)}
          text={t(race.relays.length > 1 ? 'relays' : 'relay')}
          dropdownItems={race.relays.map(r => ({ text: r.name, path: buildRelayPath(race.id, r.id) }))}
        />
      )}
      {!race.allCompetitionsFinished && (
        <DesktopMenuItem path={`/races/${race.id}/result_rotation`} text={t('resultRotation')} />
      )}
      <DesktopMenuItem path={`/races/${race.id}/medium/new`} text={t('press')} />
    </div>
  )
}
