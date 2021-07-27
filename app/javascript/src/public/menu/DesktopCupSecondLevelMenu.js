import React from 'react'
import DesktopMenuItem from './DesktopMenuItem'
import {
  buildCupMediaPath,
  buildCupPath,
  buildCupSeriesPath,
  buildRifleCupSeriesPath,
} from '../../util/routeUtil'
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
            selected={selectedPage === pages.cup.results}
            reactLink={true}
            dropdownItems={cup.cupSeries.map(cs => {
              return { text: cs.name, path: buildCupSeriesPath(cup.id, cs.id), reactLink: true }
            })}
          />
          {cup.hasRifle && (
            <DesktopMenuItem
              path={buildRifleCupSeriesPath(cup.id, cupSeriesId)}
              text={t('rifle')}
              selected={selectedPage === pages.cup.rifleResults}
              reactLink={true}
              dropdownItems={cup.cupSeries.map(cs => {
                return { text: cs.name, path: buildRifleCupSeriesPath(cup.id, cs.id), reactLink: true }
              })}
            />
          )}
          <DesktopMenuItem
            path={buildCupMediaPath(cup.id)}
            text={t('press')}
            selected={selectedPage === pages.cup.media}
            reactLink={true}
          />
        </>
      )}
    </div>
  )
}
