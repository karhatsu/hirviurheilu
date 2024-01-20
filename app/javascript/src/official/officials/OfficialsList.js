import React, { useCallback } from 'react'
import Button from '../../common/Button'
import { resolveClubsTitle } from '../../util/clubUtil'
import useAppData from '../../util/useAppData'
import useTranslation from '../../util/useTranslation'

const OfficialsList = ({ race, officials, onEdit, onDelete }) => {
  const { t } = useTranslation()
  const { userId: currentUserId } = useAppData()

  const resolveRightsText = useCallback((onlyAddCompetitors, newClubs, club) => {
    if (!onlyAddCompetitors) return 'Täydet oikeudet'
    let clubRights = 'Kaikki nykyiset'
    if (newClubs) clubRights = 'Lisäys sallittu'
    else if (club) clubRights = club.name
    return `${resolveClubsTitle(t, race.clubLevel)}: ${clubRights}`
  }, [t, race.clubLevel])

  return officials.map((official, index) => {
    const { id, userId, firstName, lastName, email, primary, onlyAddCompetitors, newClubs, club } = official
    return (
      <div key={id} className="col-xs-12 col-sm-6">
        <div className="card">
          <div className="card__middle">
            <div className="card__name">{lastName} {firstName}</div>
            <div className="card__middle-row">
              <a href={`mailto:${email}`}>{email}</a>
            </div>
            <div className="card__middle-row">{resolveRightsText(onlyAddCompetitors, newClubs, club)}</div>
          </div>
          {!primary && userId !== currentUserId && (
            <div className="card__buttons">
              <Button onClick={() => onEdit(official)} type="edit">Muokkaa oikeuksia</Button>
              <Button id={`delete_button_${index}`} onClick={() => onDelete(id)} type="danger">Peruuta kutsu</Button>
            </div>
          )}
        </div>
      </div>
    )
  })
}

export default OfficialsList
