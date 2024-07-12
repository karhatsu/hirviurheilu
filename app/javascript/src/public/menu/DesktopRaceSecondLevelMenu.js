import React from 'react'
import DesktopMenuItem from './DesktopMenuItem'
import {
  buildFinalRoundBatchesPath,
  buildNordicResultsPath, buildNordicSeriesResultsPath,
  buildQualificationRoundBatchesPath, buildRaceMediaPath,
  buildRacePath,
  buildRelayPath, buildResultRotationPath,
  buildRifleTeamCompetitionsPath,
  buildSeriesResultsPath,
  buildSeriesRifleResultsPath,
  buildSeriesShotgunsResultsPath,
  buildSeriesStartListPath,
  buildTeamCompetitionsPath,
} from '../../util/routeUtil'
import useMenu, { pages } from '../../util/useMenu'
import { useParams } from 'react-router-dom'
import useTranslation from '../../util/useTranslation'
import { useResultRotation } from '../result-rotation/useResultRotation'

export default function DesktopRaceSecondLevelMenu({ race }) {
  const { t } = useTranslation()
  const { selectedPage } = useMenu()
  const { seriesId: urlSeriesId } = useParams()
  const { started: resultRotationStarted } = useResultRotation()
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
          {race.sport.nordic && !race.nordicSubResultsForSeries && (
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
          {race.sport.nordic && race.nordicSubResultsForSeries && (
            <>
              {['trap', 'shotgun', 'rifle_moving', 'rifle_standing'].map(subSport => {
                return (
                  <DesktopMenuItem
                    key={subSport}
                    path={buildNordicSeriesResultsPath(race.id, seriesId, subSport)}
                    text={t(`nordic_${subSport}`)}
                    selected={selectedPage === pages.nordic[subSport]}
                    reactLink={true}
                    dropdownItems={race.series.map(s => {
                      return {
                        text: s.name,
                        path: buildNordicSeriesResultsPath(race.id, s.id, subSport),
                        reactLink: true,
                      }
                    })}
                  />
                )
              })}
            </>
          )}
          {race.sport.european && (
            <>
              <DesktopMenuItem
                path={buildSeriesRifleResultsPath(race.id, seriesId)}
                text={t('rifle')}
                selected={selectedPage === pages.europeanRifle}
                reactLink={true}
                dropdownItems={race.series.map(s => (
                  { text: s.name, path: buildSeriesRifleResultsPath(race.id, s.id), reactLink: true }),
                )}
              />
              {race.showEuropeanShotgunResults && (
                <DesktopMenuItem
                  path={buildSeriesShotgunsResultsPath(race.id, seriesId)}
                  text={t('european_shotgun')}
                  selected={selectedPage === pages.europeanShotgun}
                  reactLink={true}
                  dropdownItems={race.series.map(s => (
                    { text: s.name, path: buildSeriesShotgunsResultsPath(race.id, s.id), reactLink: true }),
                  )}
                />
              )}
            </>
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
          path={buildResultRotationPath(race.id)}
          text={t('resultRotation')}
          selected={selectedPage === pages.resultRotation || resultRotationStarted}
          reactLink={true}
        />
      )}
      {race.series.length > 0 && (
        <DesktopMenuItem
          path={buildRaceMediaPath(race.id)}
          text={t('press')}
          selected={selectedPage === pages.media}
          reactLink={true}
        />
      )}
    </div>
  )
}
