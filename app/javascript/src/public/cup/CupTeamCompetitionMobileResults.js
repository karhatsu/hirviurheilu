import { useState } from 'react'
import classnames from 'classnames-minimal'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'
import CupTeamCompetitionPoints from './CupTeamCompetitionPoints'
import CupTotalPoints from './CupTotalPoints'

const CupTeamCompetitionMobileResults = ({ cupTeamCompetition }) => {
  const { t } = useTranslation()
  const [showRaces, setShowRaces] = useState(false)
  const buttonKey = showRaces ? 'hideCupCompetitions' : 'showCupCompetitions'
  const { cupTeams } = cupTeamCompetition

  return (
    <>
      <Button onClick={() => setShowRaces(s => !s)}>{t(buttonKey)}</Button>
      <div className="result-cards">
        {cupTeams.map((cupTeam, i) => {
          const { name, races } = cupTeam
          const className = classnames({ card: true, 'card--odd': i % 2 === 0 })
          return (
            <div key={name} className={className}>
              <div className="card__number">{i + 1}.</div>
              <div className="card__middle">
                <div className="card__name">{name}</div>
                {showRaces && (
                  <div className="card__middle-row">
                    <div className="row">
                      {races.map(race => {
                        const { team, id } = race
                        if (team) {
                          return (
                            <div key={id} className="col-xs-12 col-sm-6 col-md-4">
                              {race.name}{' '}
                              <CupTeamCompetitionPoints raceId={id} team={team} cupTeam={cupTeam} />
                            </div>
                          )
                        }
                        return null
                      })}
                    </div>
                  </div>
                )}
              </div>
              <div className="card__main-value"><CupTotalPoints cupCompetitor={cupTeam} /></div>
            </div>
          )
        })}
      </div>
    </>
  )
}

export default CupTeamCompetitionMobileResults
