import React, { useCallback, useState } from 'react'
import useTranslation from '../../util/useTranslation'
import Message from '../../common/Message'
import Batch from './Batch'
import useRaceData from '../../util/useRaceData'
import IncompletePage from '../../common/IncompletePage'
import Button from '../../common/Button'
import { buildRacePath } from '../../util/routeUtil'
import SeriesSelect from '../race-page/SeriesSelect'
import useTitle from '../../util/useTitle'

export default function Batches({ buildApiPath, buildPdfPath, hideAttribute, trackPlaceAttribute, titleKey }) {
  const { t } = useTranslation()
  const [seriesId, setSeriesId] = useState(undefined)
  const { fetching, error, race, raceData: batchData } = useRaceData(buildApiPath)
  const selectSeries = useCallback(event => {
    const id = event.target.value
    setSeriesId(id && parseInt(id))
  }, [])
  const title = !race || race.sport.oneBatchList ? t('batchList') : t(titleKey)
  useTitle(race && [title, race.name, t(`sport_${race.sportKey}`)])
  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={title} />
  }
  const { batches } = batchData
  const hidden = race[hideAttribute]
  const content = () => {
    if (hidden) return <Message type="info">{t('batchListNotPublished')}</Message>
    else if (!batches.length) return <Message type="info">{t('batchListNotCreated')}</Message>
    else {
      return (
        <>
          {race.series.length > 0 && (
            <div className="form__field form__field--md">
              <SeriesSelect series={race.series} onChange={selectSeries} />
            </div>
          )}
          <div className="row">
            {batches.map(batch => (
              <Batch
                key={batch.number}
                race={race}
                batch={batch}
                trackPlaceAttribute={trackPlaceAttribute}
                seriesId={seriesId}
              />
            ))}
          </div>
        </>
      )
    }
  }
  return (
    <>
      <h2>{title}</h2>
      {content()}
      {!hidden && (
        <div className="buttons">
          <Button href={buildPdfPath(race.id)} type="pdf">{t('downloadBatchListPdf')}</Button>
        </div>
      )}
      <div className="buttons buttons--nav">
        <Button to={buildRacePath(race.id)} type="back">{t('backToPage', { pageName: race.name })}</Button>
      </div>
    </>
  )
}
