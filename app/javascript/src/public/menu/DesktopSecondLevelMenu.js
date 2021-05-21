import React from 'react'
import { useRace } from '../../util/useRace'
import DesktopMenuItem from './DesktopMenuItem'
import useTranslation from '../../util/useTranslation'
import { useParams } from 'react-router-dom'
import {
  buildRelayLink,
  buildSeriesResultsLink,
  buildSeriesStartListLink,
  buildTeamCompetitionsLink,
} from '../../util/routeUtil'

export default function DesktopSecondLevelMenu() {
  const { seriesId: urlSeriesId } = useParams()
  const { t } = useTranslation()
  const { race } = useRace()
  if (!race || race.cancelled) return null
  const seriesId = urlSeriesId || (race.series.length > 0 && race.series[0].id)
  return (
    <div className="menu menu--sub menu--sub-1">
      <DesktopMenuItem path={`/races/${race.id}`} text={t('raceMenuHome')} />
      {seriesId && (
        <>
          <DesktopMenuItem
            path={buildSeriesResultsLink(race.id, seriesId)}
            text={t('results')}
            dropdownItems={race.series.map(s => ({ text: s.name, path: buildSeriesResultsLink(race.id, s.id) }))}
          />
          <DesktopMenuItem
            path={buildSeriesStartListLink(race.id, seriesId)}
            text={t('startList')}
            selected={true}
            reactLink={true}
            dropdownItems={race.series.map(s => ({ text: s.name, path: buildSeriesStartListLink(race.id, s.id), reaactLink: true }))}
          />
        </>
      )}
      {race.teamCompetitions.length > 0 && (
        <DesktopMenuItem
          path={buildTeamCompetitionsLink(race.id, race.teamCompetitions[0].id)}
          text={t('teamCompetitions')}
          dropdownItems={race.teamCompetitions.map(tc => ({ text: tc.name, path: buildTeamCompetitionsLink(race.id, tc.id) }))}
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
        <DesktopMenuItem path={`/races/${race.id}/result_rotation`} text={t('Resultatskrets')} />
      )}
      <DesktopMenuItem path={`/races/${race.id}/medium/new`} text={t('press')} />
    </div>
  )
}
