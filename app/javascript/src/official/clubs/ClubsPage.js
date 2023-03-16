import React, { useCallback, useEffect, useState } from 'react'
import Button from '../../common/Button'
import { buildOfficialRacePath } from '../../util/routeUtil'
import useTranslation from '../../util/useTranslation'
import { useRace } from '../../util/useRace'
import { resolveClubsTitle, resolveClubTitle } from '../../util/clubUtil'
import IncompletePage from '../../common/IncompletePage'
import { raceEnums } from '../../util/enums'
import { del, get, post, put } from '../../util/apiClient'
import ClubForm from './ClubForm'
import Message from '../../common/Message'
import { competitorsCountLabel } from '../../util/competitorUtil'
import useOfficialMenu from '../menu/useOfficialMenu'

const clubsSorter = (a, b) => a.name.localeCompare(b.name)

const ClubsPage = () => {
  const { t } = useTranslation()
  const [clubs, setClubs] = useState(undefined)
  const [clubsError, setClubsError] = useState()
  const [deleteError, setDeleteError] = useState()
  const [formErrors, setFormErrors] = useState()
  const [adding, setAdding] = useState(false)
  const [editing, setEditing] = useState()
  const { fetching, error, race } = useRace()
  const { setSelectedPage } = useOfficialMenu()

  useEffect(() => setSelectedPage('clubs'), [setSelectedPage])

  useEffect(() => {
    if (race) {
      get(`/official/races/${race.id}/clubs.json`, (err, response) => {
        if (err) setClubsError(err[0])
        else setClubs(response.clubs)
      })
    }
  }, [race])

  const onCreate = useCallback(data => {
    post(`/official/races/${race.id}/clubs.json`, { club: data }, (errors, response) => {
      if (errors) {
        setFormErrors(errors)
      } else {
        setClubs(clubs => [...clubs, response].sort(clubsSorter))
        setAdding(false)
      }
    })
  }, [race])

  const onUpdate = useCallback(data => {
    const club = { name: data.name, longName: data.longName }
    put(`/official/races/${race.id}/clubs/${data.id}.json`, { club }, (errors, response) => {
      if (errors) {
        setFormErrors(errors)
      } else {
        setClubs(clubs => {
          const index = clubs.findIndex(c => c.id === data.id)
          const newClubs = [...clubs]
          newClubs[index] = { ...response }
          return newClubs.sort(clubsSorter)
        })
        setEditing(undefined)
      }
    })
  }, [race])

  const onDelete = useCallback(id => {
    del(`/official/races/${race.id}/clubs/${id}`, errors => {
      if (errors) {
        setDeleteError(errors[0])
      } else {
        setClubs(clubs => {
          const index = clubs.findIndex(c => c.id === id)
          const newClubs = [...clubs]
          newClubs.splice(index, 1)
          return newClubs
        })
      }
    })
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

  if (adding) {
    const title = `${t('add')} ${resolveClubTitle(t, race.clubLevel).toLowerCase()}`
    const initialData = { name: '', longName: '' }
    return (
      <ClubForm
        errors={formErrors}
        initialData={initialData}
        onCancel={() => setAdding(false)}
        onSave={onCreate}
        title={title}
      />
    )
  }

  if (editing) {
    const title = `${editing.name} - ${t('edit')}`
    return (
      <ClubForm
        errors={formErrors}
        initialData={editing}
        onCancel={() => setEditing(undefined)}
        onSave={onUpdate}
        title={title}
      />
    )
  }

  return (
    <div>
      <h2 id="clubs_title">{resolveClubsTitle(t, race.clubLevel)}</h2>
      <div className="message message--info">{t('clubsPageInfo')}</div>
      {deleteError && <Message type="error">{deleteError}</Message>}
      <div className="row">
        {clubs.map(club => (
          <div key={club.id} className="col-xs-12 col-sm-6 col-md-4">
            <div className="card">
              <div className="card__middle">
                <div className="card__name">{club.name}</div>
                {club.longName && <div className="card__middle-row">{club.longName}</div>}
                <div className="card__middle-row">{competitorsCountLabel(t, club.competitorsCount)}</div>
              </div>
              <div className="card__buttons">
                <Button type="edit" onClick={() => setEditing(club)}>Muokkaa</Button>
                {club.canBeRemoved && <Button type="danger" onClick={() => onDelete(club.id)}>Poista</Button>}
              </div>
            </div>
          </div>
        ))}
      </div>
      <div className="buttons">
        <Button type="add" onClick={() => setAdding(true)} id="add_button">
          {t('add')} {resolveClubTitle(t, race.clubLevel).toLowerCase()}
        </Button>
      </div>
      <div className="buttons buttons--nav">
        <Button to={buildOfficialRacePath(race.id)} type="back">{t('backToOfficialRacePage')}</Button>
      </div>
    </div>
  )
}

export default ClubsPage
