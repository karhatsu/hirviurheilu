import React from 'react'
import DesktopMenuItem from './DesktopMenuItem'
import { buildCupMediaPath, buildCupPath, buildCupSeriesPath, buildRifleCupSeriesPath } from '../../util/routeUtil'
import { pages } from './DesktopSecondLevelMenu'
import useTranslation from '../../util/useTranslation'

export default function DesktopCupSecondLevelMenu({ cup, selectedPage }) {
  const { t } = useTranslation()
  const cupSeriesId = cup.cupSeries.length > 0 && cup.cupSeries[0].id
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
          />
          {cup.hasRifle && (
            <DesktopMenuItem
              path={buildRifleCupSeriesPath(cup.id, cupSeriesId)}
              text={t('rifle')}
            />
          )}
          <DesktopMenuItem
            path={buildCupMediaPath(cup.id)}
            text={t('press')}
          />
        </>
      )}
    </div>
  )
}
