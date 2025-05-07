import isAfter from 'date-fns/isAfter'
import parseISO from 'date-fns/parseISO'
import useTranslation from '../../util/useTranslation'
import ClubSelect from './ClubSelect'
import Button from '../../common/Button'
import { buildRacePath } from '../../util/routeUtil'

export default function RaceResultsPdf({ race }) {
  const { t } = useTranslation()
  const { clubLevel, clubs, series, startDate } = race
  if (!series.length || isAfter(parseISO(startDate), new Date())) return null
  return (
    <>
      <h2>{t('raceResultsPdf')}</h2>
      <form action={`${buildRacePath(race.id)}.pdf`} method="GET" className="form">
        <div className="form__horizontal-fields">
          <div className="form__field">
            <ClubSelect clubLevel={clubLevel} clubs={clubs} />
          </div>
          <div className="form__field">
            <input type="checkbox" name="page_breaks" />
            <label htmlFor="page_breaks">{t('pdfPageBreaks')}</label>
          </div>
          <div className="form__buttons">
            <Button submit={true} type="pdf">
              {t('downloadAllResults')}
            </Button>
          </div>
        </div>
      </form>
    </>
  )
}
