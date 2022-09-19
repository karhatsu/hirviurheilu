import React, { useEffect, useState } from 'react'
import Button from '../../common/Button'
import { buildOfficialRacePath } from '../../util/routeUtil'
import useTranslation from '../../util/useTranslation'
import { useRace } from '../../util/useRace'
import { resolveClubsTitle, resolveClubTitle } from '../../util/clubUtil'
import IncompletePage from '../../common/IncompletePage'
import { raceEnums } from '../../util/enums'
import { get } from '../../util/apiClient'

const ClubsPage = () => {
  const { t } = useTranslation()
  const [clubs, setClubs] = useState(undefined)
  const [clubsError, setClubsError] = useState()
  const { fetching, error, race } = useRace()

  useEffect(() => {
    if (race) {
      get(`/official/races/${race.id}/clubs.json`, (err, response) => {
        if (err) setClubsError(err[0])
        else setClubs(response.clubs)
      })
    }
  }, [race])

  if (!race || !clubs) {
    return (
      <IncompletePage
        fetching={fetching}
        error={error || clubsError}
        title={resolveClubsTitle(t, raceEnums.clubLevel.club)}
      />
    )
  }

  return (
    <div>
      <h2>{resolveClubsTitle(t, race.clubLevel)}</h2>
      <div className="message message--info">{t('clubsPageInfo')}</div>
      <div className="row">
        {clubs.map(club => (
          <div key={club.id} className="col-xs-12 col-sm-6 col-md-4">
            <div className="card">
              <div className="card__middle">
                <div className="card__name">{club.name}</div>
                {club.longName && <div className="card__middle-row">{club.longName}</div>}
                <div className="card__middle-row">
                  {t('clubsPageCompetitorsCount', { count: club.competitorsCount })}
                </div>
              </div>
              <div className="card__buttons">
                <Button to="/" type="edit">Muokkaa</Button>
                {club.canBeRemoved && <Button to="/" type="danger">Poista</Button>}
              </div>
            </div>
          </div>
        ))}
      </div>
      <div className="buttons">
        <Button to="/" type="add">{t('add')} {resolveClubTitle(t, race.clubLevel).toLowerCase()}</Button>
      </div>
      <div className="buttons buttons--nav">
        <Button to={buildOfficialRacePath(race.id)} type="back">{t('backToOfficialRacePage')}</Button>
      </div>
    </div>
  )
}

export default ClubsPage
