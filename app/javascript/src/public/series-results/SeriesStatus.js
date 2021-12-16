import React from 'react'
import parseISO from 'date-fns/parseISO'
import useTranslation from '../../util/useTranslation'
import Message from '../../common/Message'
import { formatTodaysTime } from '../../util/timeUtil'
import useAppData from '../../util/useAppData'

export default function SeriesStatus({ children, race, series }) {
  const { t } = useTranslation()
  const { staging } = useAppData()
  let info
  if (!series.competitorsCount) {
    info = t('seriesNoCompetitors')
  } else if (race.sport.startList && !series.hasStartList) {
    info = t('seriesNoStartList')
  } else if (race.sport.startList && !series.started && !staging) {
    info = `${t('seriesStartTime')}: ${formatTodaysTime(parseISO(series.startTime))}`
  }
  if (info) {
    return <Message type="info">{info}</Message>
  }
  return children
}
