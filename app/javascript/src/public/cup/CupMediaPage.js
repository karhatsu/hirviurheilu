import React, { useEffect, useState } from 'react'
import { pages } from '../menu/DesktopSecondLevelMenu'
import useTranslation from '../../util/useTranslation'
import { get } from '../../util/apiClient'
import Message from '../../common/Message'
import Button from '../../common/Button'
import { buildCupPath } from '../../util/routeUtil'
import IncompletePage from '../../common/IncompletePage'
import { useParams } from 'react-router-dom'

export default function CupMediaPage({ setSelectedPage }) {
  const { t } = useTranslation()
  const { cupId } = useParams()
  const [fetching, setFetching] = useState(true)
  const [error, setError] = useState(undefined)
  const [cup, setCup] = useState(undefined)
  const [competitorsCount, setCompetitorsCount] = useState(3)
  useEffect(() => setSelectedPage(pages.cup.media), [setSelectedPage])

  useEffect(() => {
    get(`/api/v2/public/cups/${cupId}?results=true`, (err, data) => {
      if (err) {
        setError('Odottamaton virhe')
      } else {
        setCup(data)
        setError(undefined)
      }
      setFetching(false)
    })
  }, [cupId])

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={t('press')} />
  }

  const ruleKey = cup.includeAlwaysLastRace ? 'cupPointsRuleWithLast' : 'cupPointsRule'
  return (
    <>
      <h2>{t('press')}</h2>
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
      </div>
      <Message type="info">{t('pressReportInstructions')}</Message>
      {t(ruleKey, { bestCompetitionsCount: cup.topCompetitions })}.{' '}
      {cup.cupSeries.map(cupSeries => {
        const competitors = cupSeries.cupCompetitors
          .map((competitor, i) => {
            const { clubName, firstName, lastName, points } = competitor
            if (i < competitorsCount && points) {
              return `${i + 1}) ${lastName} ${firstName} ${clubName} ${points}`
            }
            return undefined
          })
          .filter(c => c)
          .join(', ')
        return `${cupSeries.name}: ${competitors}`
      }).join('. ')}.
      <div className="buttons buttons--nav">
        <Button to={buildCupPath(cupId)} type="back">{t('backToPage', { pageName: cup.name })}</Button>
      </div>
    </>
  )
}
