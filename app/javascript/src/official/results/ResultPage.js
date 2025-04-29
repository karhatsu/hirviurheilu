import SeriesMobileSubMenu from "../../public/menu/SeriesMobileSubMenu"
import {
  buildOfficialRaceCompetitorsPath,
  buildOfficialRacePath,
  buildOfficialSeriesEstimatesPath,
  buildOfficialSeriesShotsPath,
  buildOfficialSeriesTimesPath,
} from "../../util/routeUtil"
import Button from "../../common/Button"
import useTranslation from "../../util/useTranslation"
import Message from "../../common/Message"

const ResultPage = ({ competitorClass, children, race, series, titleKey, renderAboveCompetitors }) => {
  const { t } = useTranslation()
  const { id: seriesId, raceId } = series

  const content = () => {
    if (!series.competitors.length) {
      return <Message type="info">{t('noCompetitorsInSeries')}</Message>
    } else if (race.sport.startList && !series.hasStartList) {
      return (
        <>
          <Message type="info">{t('noStartListForSeries')}</Message>
          <Button href={buildOfficialRaceCompetitorsPath(raceId, seriesId)}>{t('generateStartTimes')}</Button>
        </>
      )
    } else {
      return (
        <>
          {renderAboveCompetitors?.()}
          <div className="row">
            {series.competitors.map(competitor => (
              <div key={competitor.id} className={competitorClass || 'col-sm-12'}>
                {children(competitor)}
              </div>
            ))}
          </div>
        </>
      )
    }
  }

  return (
    <div>
      <h2>{series.name} - {t(titleKey)}</h2>
      {content()}
      {race.series.length > 1 && (
        <SeriesMobileSubMenu
          race={race}
          buildSeriesPath={buildOfficialSeriesEstimatesPath}
          currentSeriesId={seriesId}
        />
      )}
      <div className="buttons buttons--nav">
        <Button href={buildOfficialRacePath(raceId)} type="back">{t('backToOfficialRacePage')}</Button>
        {titleKey !== 'officialRaceMenuTimes' && (
          <Button to={buildOfficialSeriesTimesPath(raceId, seriesId)}>{t('officialRaceMenuTimes')}</Button>
        )}
        {titleKey !== 'officialRaceMenuEstimates' && (
          <Button to={buildOfficialSeriesEstimatesPath(raceId, seriesId)}>{t('officialRaceMenuEstimates')}</Button>
        )}
        {titleKey !== 'officialRaceMenuShooting' && (
          <Button to={buildOfficialSeriesShotsPath(raceId, seriesId)}>{t('officialRaceMenuShooting')}</Button>
        )}
      </div>
    </div>
  )
}

export default ResultPage
