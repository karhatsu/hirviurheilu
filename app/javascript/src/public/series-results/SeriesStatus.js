import React from 'react'
import parseISO from 'date-fns/parseISO'
import useTranslation from '../../util/useTranslation'
import Message from '../../common/Message'
import { formatTodaysTime } from '../../util/timeUtil'

export default function SeriesStatus({ children, race, series }) {
  const { t } = useTranslation()
  let info
  if (!series.competitorsCount) {
    info = t('seriesNoCompetitors')
  } else if (race.sport.startList && !series.hasStartList) {
    info = t('seriesNoStartList')
  } else if (race.sport.startList && !series.started) {
    info = `${t('seriesStartTime')}: ${formatTodaysTime(parseISO(series.startTime))}`
  }
  if (info) {
    return <Message type="info">{info}</Message>
  }
  return children
}
