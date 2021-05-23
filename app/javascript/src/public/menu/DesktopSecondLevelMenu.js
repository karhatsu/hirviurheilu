import React from 'react'
import { useRace } from '../../util/useRace'
import DesktopMenuItem from './DesktopMenuItem'
import useTranslation from '../../util/useTranslation'
import { useParams, useRouteMatch } from 'react-router-dom'
import {
  buildFinalRoundBatchesLink,
  buildNordicResultsLink,
  buildQualificationRoundBatchesLink,
  buildRaceLink,
  buildRelayLink,
  buildRifleTeamCompetitionsLink,
  buildSeriesResultsLink,
  buildSeriesRifleResultsLink,
  buildSeriesStartListLink,
  buildTeamCompetitionsLink,
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
        path={buildRaceLink(race.id)}
        text={t('raceMenuHome')}
        reactLink={true}
        selected={isHomePage}
      />
      {seriesId && (
        <>
          <DesktopMenuItem
            path={buildSeriesResultsLink(race.id, seriesId)}
            text={t('results')}
            dropdownItems={race.series.map(s => ({ text: s.name, path: buildSeriesResultsLink(race.id, s.id) }))}
          />
          {race.sport.nordic && (
            <>
              {['trap', 'shotgun', 'rifle_standing', 'rifle_moving'].map(subSport => {
                return (
                  <DesktopMenuItem
                    key={subSport}
                    path={buildNordicResultsLink(race.id, subSport)}
                    text={t(`nordic_${subSport}`)}
                  />
                )
              })}
            </>
          )}
          {race.sport.european && (
            <DesktopMenuItem
              path={buildSeriesRifleResultsLink(race.id, seriesId)}
              text={t('rifle')}
              dropdownItems={race.series.map(s => ({ text: s.name, path: buildSeriesRifleResultsLink(race.id, s.id) }))}
            />
          )}
          {race.sport.batchList && race.qualificationRoundBatches.length > 0 && (
            <DesktopMenuItem
              path={buildQualificationRoundBatchesLink(race.id)}
              text={t(race.sport.oneBatchList ? 'batchLists' : 'qualificationRoundBatchLists')}
            />
          )}
          {race.sport.batchList && race.finalRoundBatches.length > 0 && (
            <DesktopMenuItem
              path={buildFinalRoundBatchesLink(race.id)}
              text={t('finalRoundBatchLists')}
            />
          )}
          {race.sport.startList && (
            <DesktopMenuItem
              path={buildSeriesStartListLink(race.id, seriesId)}
              text={t('startList')}
              routeMatch="/:lang?/races/:raceId/series/:seriesId/start_list"
              reactLink={true}
              dropdownItems={race.series.map(s => {
                return { text: s.name, path: buildSeriesStartListLink(race.id, s.id), reactLink: true }
              })}
            />
          )}
        </>
      )}
      {race.teamCompetitions.length > 0 && (
        <DesktopMenuItem
          path={buildTeamCompetitionsLink(race.id, race.teamCompetitions[0].id)}
          text={t('teamCompetitions')}
          dropdownItems={race.teamCompetitions.map(tc => {
            return { text: tc.name, path: buildTeamCompetitionsLink(race.id, tc.id) }
          })}
        />
      )}
      {race.sport.european && race.teamCompetitions.length > 0 && (
        <DesktopMenuItem
          path={buildRifleTeamCompetitionsLink(race.id, race.teamCompetitions[0].id)}
          text={t('rifleTeamCompetitions')}
          dropdownItems={race.teamCompetitions.map(tc => {
            return { text: tc.name, path: buildRifleTeamCompetitionsLink(race.id, tc.id) }
          })}
        />
      )}
      {race.relays.length > 0 && (
        <DesktopMenuItem
          path={buildRelayLink(race.id, race.relays[0].id)}
          text={t('relays')}
          dropdownItems={race.relays.map(r => ({ text: r.name, path: buildRelayLink(race.id, r.id) }))}
        />
      )}
      {!race.allCompetitionsFinished && (
        <DesktopMenuItem path={`/races/${race.id}/result_rotation`} text={t('resultRotation')} />
      )}
      <DesktopMenuItem path={`/races/${race.id}/medium/new`} text={t('press')} />
    </div>
  )
}
