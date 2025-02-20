import React, { useEffect, useMemo, useState } from 'react'
import useOfficialMenu from "../menu/useOfficialMenu"
import { pages } from "../../util/useMenu"
import IncompletePage from "../../common/IncompletePage"
import useTranslation from "../../util/useTranslation"
import { get } from "../../util/apiClient"
import { useParams } from "react-router"

const EventCompetitorsPage = () => {
  const { eventId } = useParams()
  const { t } = useTranslation()
  const { setSelectedPage } = useOfficialMenu()
  const [event, setEvent] = useState()
  const [error, setError] = useState()
  const fetching = !event && !error

  useEffect(() => setSelectedPage(pages.events.competitors), [setSelectedPage])

  useEffect(() => {
    get(`/official/events/${eventId}/competitors.json`, (err, data) => {
      if (err) return setError(err)
      setEvent(data)
    })
  }, [eventId])

  const competitorsMap = useMemo(() => {
    if (!event) return {}
    const map = {}
    event.races.forEach(race => {
      const { id: raceId, name: raceName } = race
      race.series.forEach(series => {
        series.competitors.forEach(competitor => {
          const { number, lastName, firstName, club } = competitor
          const key = `${number}_${lastName}_${firstName}_${club.name}`
          const comp = { number, lastName, firstName, club: club.name, series: series.name, race: raceName, raceId }
          if (map[key]) {
            map[key].push(comp)
          } else {
            map[key] = [comp]
          }
        })
      })
    })
    return map
  }, [event])

  const sortedKeys = useMemo(() => {
    if (!competitorsMap) return []
    return Object.keys(competitorsMap).sort((a, b) => {
      const aParts = a.split('_')
      const bParts = b.split('_')
      if (aParts[0] !== bParts[0]) return parseInt(aParts[0]) - parseInt(bParts[0])
      const lastNameComp = aParts[1].localeCompare(bParts[1])
      if (lastNameComp) return lastNameComp
      return aParts[2].localeCompare(bParts[2])
    })
  }, [competitorsMap])

  if (fetching || error) {
    return <IncompletePage fetching={fetching} error={error} title={t('officialEventMenuCompetitors')} />
  }

  return (
    <div>
      <h2>{t('officialEventMenuCompetitors')}</h2>
      <div className="row">
        {sortedKeys.map(key => {
          const competitors = competitorsMap[key]
          const { number, lastName, firstName, club } = competitors[0]
          return (
            <div key={key} className="col-xs-12 col-sm-6 col-md-4">
              <div className="card">
                <div className="card__number">{number}</div>
                <div className="card__middle">
                  <div className="card__name">{lastName} {firstName}</div>
                  <div className="card__middle-row">{club}</div>
                  {competitors.map(competitorInRace => (
                    <div className="card__middle-row" key={competitorInRace.raceId}>
                      {competitorInRace.race} ({competitorInRace.series})
                    </div>
                  ))}
                </div>
              </div>
            </div>
          )
        })}
      </div>
    </div>
  )
}

export default EventCompetitorsPage
