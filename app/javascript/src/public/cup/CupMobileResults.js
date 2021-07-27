import React, { useState } from 'react'
import classnames from 'classnames-minimal'
import Button from '../../common/Button'
import useTranslation from '../../util/useTranslation'
import CupTotalPoints from './CupTotalPoints'
import CupPoints from './CupPoints'

export default function CupMobileResults({ cupSeries }) {
  const { t } = useTranslation()
  const [showRaces, setShowRaces] = useState(false)
  const buttonKey = showRaces ? 'hideCupCompetitions' : 'showCupCompetitions'
  const { cupCompetitors, seriesNames } = cupSeries
  const showSeries = !!(seriesNames && seriesNames !== name)
  return (
    <>
      <Button onClick={() => setShowRaces(s => !s)}>{t(buttonKey)}</Button>
      <div className="result-cards">
        {cupCompetitors.map((cupCompetitor, i) => {
          const { firstName, lastName, races, seriesNames } = cupCompetitor
          const className = classnames({ card: true, 'card--odd': i % 2 === 0 })
          const name = `${lastName} ${firstName}`
          return (
            <div key={name} className={className}>
              <div className="card__number">{i + 1}.</div>
              <div className="card__middle">
                <div className="card__name">{name} {showSeries && ` (${seriesNames})`}</div>
                {showRaces && (
                  <div className="card__middle-row">
                    <div className="row">
                      {races.map(race => {
                        const { competitor, id } = race
                        if (competitor) {
                          return (
                            <div key={id} className="col-xs-12 col-sm-6 col-md-4">
                              {race.name}{' '}
                              <CupPoints raceId={id} competitor={competitor} cupCompetitor={cupCompetitor} />
                            </div>
                          )
                        }
                        return null
                      })}
                    </div>
                  </div>
                )}
              </div>
              <div className="card__main-value"><CupTotalPoints cupCompetitor={cupCompetitor} /></div>
            </div>
          )
        })}
      </div>
    </>
  )
}
