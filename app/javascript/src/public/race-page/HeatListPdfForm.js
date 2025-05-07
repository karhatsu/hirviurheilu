import ClubSelect from './ClubSelect'
import SeriesSelect from './SeriesSelect'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'

export default function HeatListPdfForm({ path, race, title }) {
  const { t } = useTranslation()
  const { clubLevel, clubs, series } = race
  return (
    <>
      <h2>{title} (PDF)</h2>
      <form action={`${path}.pdf`} method="GET" className="form">
        <div className="form__horizontal-fields">
          <div className="form__field">
            <SeriesSelect series={series} />
          </div>
          <div className="form__field">
            <ClubSelect clubLevel={clubLevel} clubs={clubs} />
          </div>
          <div className="form__buttons">
            <Button submit={true} type="pdf">
              {t('downloadHeatList')}
            </Button>
          </div>
        </div>
      </form>
    </>
  )
}
