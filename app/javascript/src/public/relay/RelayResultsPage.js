import React, { useCallback, useEffect, useMemo } from 'react'
import format from 'date-fns/format'
import max from 'date-fns/max'
import parseISO from 'date-fns/parseISO'
import { pages } from '../menu/DesktopSecondLevelMenu'
import useTranslation from '../../util/useTranslation'
import { useParams } from 'react-router-dom'
import useLayout from '../../util/useLayout'
import useRaceData from '../../util/useRaceData'
import IncompletePage from '../../common/IncompletePage'
import RelayStatus from './RelayStatus'
import RelayDesktopResults from './RelayDesktopResults'
import Button from '../../common/Button'
import { buildRacePath, buildRelayPath, buildRelayStartListPath } from '../../util/routeUtil'
import RelayMobileResults from './RelayMobileResults'
import RelayLegDesktopResults from './RelayLegDesktopResults'
import RelayLegMobileResults from './RelayLegMobileResults'
import useRelaySorting from './useRelaySorting'
import useTitle from '../../util/useTitle'
import useDataReloading from '../../util/useDataReloading'
import MobileSubMenu from '../menu/MobileSubMenu'

export default function RelayResultsPage({ setSelectedPage }) {
  const { t } = useTranslation()
  const { relayId: relayIdStr, leg: legParam } = useParams()
  const relayId = parseInt(relayIdStr)
  const leg = legParam ? parseInt(legParam) : undefined
  const { mobile } = useLayout()
  const buildApiPath = useCallback(raceId => {
    return `/api/v2/public/races/${raceId}/relays/${relayId}`
  }, [relayId])
  const { fetching, error, race, raceData: relay, reloadDataRef } = useRaceData(buildApiPath)
  useEffect(() => setSelectedPage(pages.relays), [setSelectedPage])
  const { teams } = useRelaySorting(relay, leg)

  useDataReloading('RelayChannel', 'relay_id', relayId, reloadDataRef)

  const titleRelay = (relay?.id === relayId && relay) || (race && race.relays.find(r => r.id === relayId))
  const titleSuffix = useMemo(() => {
    if (!titleRelay) return
    if (leg) return t('legNumber', { leg })
    if (!titleRelay.teams) return t('results')
    if (!titleRelay.teams.length) return t('noTeams')
    if (!titleRelay.started) return t('relayNotStarted')
    if (titleRelay.finished) return t('results')
    const maxTime = max(titleRelay.teams.map(team => team.competitors.map(c => parseISO(c.updatedAt))).flat())
    return t('resultsInProgress', { time: format(maxTime, 'dd.MM.yyyy HH:mm') })
  }, [t, titleRelay, leg])

  const title = titleRelay ? `${titleRelay.name} - ${titleSuffix}` : t('relay')
  useTitle(race && titleRelay && `${race.name} - ${t('relays')} - ${title}`)

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={title} />
  }

  const pdfPath = `${buildRelayPath(race.id, relayId)}.pdf`
  return (
    <>
      <h2>{title}</h2>
      <RelayStatus race={race} relay={relay} leg={leg}>
        {!mobile && !leg && <RelayDesktopResults race={race} relay={relay} teams={teams} />}
        {mobile && !leg && <RelayMobileResults relay={relay} teams={teams} />}
        {!mobile && leg && <RelayLegDesktopResults race={race} relay={relay} teams={teams} leg={leg} />}
        {mobile && leg && <RelayLegMobileResults relay={relay} teams={teams} leg={leg} />}
        {!leg && (
          <div className="buttons">
            <Button href={buildRelayStartListPath(race.id, relayId)} type="pdf">
              {t('downloadRelayCompetitorsPdf')}
            </Button>
            <Button href={`${pdfPath}?exclude_competitors=true`} type="pdf">
              {t('downloadResultsPdfWithoutCompetitors')}
            </Button>
            <Button href={pdfPath} type="pdf">{t('downloadResultsPdfWithCompetitors')}</Button>
          </div>
        )}
      </RelayStatus>
      <MobileSubMenu items={race.relays} currentId={relayId} parentId={race.id} buildPath={buildRelayPath} />
      <div className="buttons buttons--nav">
        <Button to={buildRacePath(race.id)} type="back">{t('backToPage', { pageName: race.name })}</Button>
      </div>
    </>
  )
}
