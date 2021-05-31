import React from 'react'
import format from 'date-fns/format'
import parseISO from 'date-fns/parseISO'
import useTranslation from '../../util/useTranslation'

export default function SeriesStatus({ children, race, series }) {
  const { t } = useTranslation()
  let info
  if (!series.competitorsCount) {
    info = t('seriesNoCompetitors')
  } else if (race.sport.startList && !series.hasStartList) {
    info = t('seriesNoStartList')
  } else if (race.sport.startList && !series.started) {
    info = `${t('seriesStartTime')}: ${format(parseISO(series.startTime), 'dd.MM.yyyy HH:mm')}`
  }
  if (info) {
    return <div className="message message--info">{info}</div>
  }
  return children
}
