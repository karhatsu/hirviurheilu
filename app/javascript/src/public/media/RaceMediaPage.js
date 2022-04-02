import React, { useCallback, useEffect, useState } from 'react'
import useMenu, { pages } from '../../util/useMenu'
import useTranslation from '../../util/useTranslation'
import Message from '../../common/Message'
import { useRace } from '../../util/useRace'
import IncompletePage from '../../common/IncompletePage'
import { raceEnums } from '../../util/enums'
import ClubSelect from '../race-page/ClubSelect'
import Button from '../../common/Button'
import { buildRacePath } from '../../util/routeUtil'
import { get } from '../../util/apiClient'
import useTitle from '../../util/useTitle'

const { clubLevel } = raceEnums

export default function RaceMediaPage() {
  const { t } = useTranslation()
  const { setSelectedPage } = useMenu()
  const [competitorsCount, setCompetitorsCount] = useState(3)
  const [clubIds, setClubIds] = useState([])
  const [report, setReport] = useState(undefined)
  const [error, setError] = useState(undefined)
  const { fetching, race, error: raceError } = useRace()
  useTitle(race && [t('press'), race.name, t(`sport_${race.sportKey}`)])
  useEffect(() => setSelectedPage(pages.media), [setSelectedPage])

  const onClubChange = useCallback(event => {
    setClubIds([...event.target.selectedOptions].map(o => parseInt(o.value)))
  }, [])

  const showForm = race && (race.finished || race.series.findIndex(s => s.finished) !== -1)
  useEffect(() => {
    if (race && showForm) {
      get(`/api/v2/public/races/${race.id}/press`, (err, data) => {
        if (err) {
          setError(true)
        } else {
          setReport(data)
          setError(false)
        }
      })
    }
  }, [race, showForm])

  if (fetching || raceError) {
    return <IncompletePage fetching={fetching} error={raceError} title={t('press')} />
  }

  const alsoFromKey = race.clubLevel === clubLevel.club ? 'alsoCompetitorsFromClubs' : 'alsoCompetitorsFromDistricts'
  return (
    <>
      <h2>{t('press')}</h2>
      {!showForm && <Message type="info">{t('pressInfoUnfinishedRace')}</Message>}
      {showForm && (
        <div className="form">
          <div className="form__field form__field--sm">
            <label htmlFor="competitor_count">{t('competitorsPerSeries')}</label>
            <input
              id="competitor_count"
              type="number"
              value={competitorsCount}
              onChange={e => setCompetitorsCount(e.target.value)}
            />
          </div>
          <div className="form__field">
            <label htmlFor="competitor_count">{t(alsoFromKey)}</label>
            <ClubSelect clubLevel={race.clubLevel} clubs={race.clubs} multiple={true} onChange={onClubChange} />
          </div>
        </div>
      )}
      {error && <Message type="error">Raportin lataus epäonnistui</Message>}
      {report && (
        <>
          <Message type="info">{t('pressReportInstructions')}</Message>
          {report.series.map(series => {
            const competitors = series.competitors
              .map((competitor, i) => {
                const { club, firstName, lastName, points, nationalRecordPassed, nationalRecordReached } = competitor
                if (i < competitorsCount || clubIds.includes(competitor.clubId)) {
                  const record = nationalRecordPassed ? ' (SE)' : (nationalRecordReached ? ' (SE sivuaa)' : '')
                  return `${i + 1}) ${lastName} ${firstName} ${club.name} ${points}${record}`
                }
                return undefined
              })
              .filter(c => c)
              .join(', ')
            return `${t('series')} ${series.name}: ${competitors}`
          }).join('. ')}.
        </>
      )}
      <div className="buttons buttons--nav">
        <Button to={buildRacePath(race.id)} type="back">{t('backToPage', { pageName: race.name })}</Button>
      </div>
    </>
  )
}
