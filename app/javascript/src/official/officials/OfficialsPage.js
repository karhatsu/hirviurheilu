import React, { useCallback, useEffect, useState } from 'react'
import useOfficialMenu from '../menu/useOfficialMenu'
import Message from '../../common/Message'
import { useRace } from '../../util/useRace'
import { del, get, post, put } from '../../util/apiClient'
import IncompletePage from '../../common/IncompletePage'
import useTranslation from '../../util/useTranslation'
import { buildOfficialRacePath } from '../../util/routeUtil'
import Button from '../../common/Button'
import OfficialForm from './OfficialForm'
import FormErrors from '../../common/form/FormErrors'
import OfficialsList from './OfficialsList'
import AddManyOfficialsForm from './AddManyOfficialsForm'

const officialsSorter = (a, b) => a.lastName.toUpperCase().localeCompare(b.lastName.toUpperCase())

const pageStates = {
  list: 0,
  add: 1,
  addMultiple: 2,
  // edit: <official object>,
}

const OfficialsPage = () => {
  const { t } = useTranslation()
  const [officials, setOfficials] = useState()
  const [officialsError, setOfficialsError] = useState()
  const [pageState, setPageState] = useState(pageStates.list)
  const [formErrors, setFormErrors] = useState()
  const { fetching, error, race } = useRace()
  const { setSelectedPage } = useOfficialMenu()

  useEffect(() => setSelectedPage('officials'), [setSelectedPage])

  useEffect(() => {
    if (race) {
      get(`/official/races/${race.id}/race_rights.json`, (err, response) => {
        if (err) setOfficialsError(err[0])
        else setOfficials(response.officials.sort(officialsSorter))
      })
    }
  }, [race])

  const resetPageState = useCallback(() => setPageState(pageStates.list), [])

  const addRights = useCallback(data => {
    const raceRight = { onlyAddCompetitors: data.onlyAddCompetitors, newClubs: data.newClubs, clubId: data.clubId }
    const body = { email: data.email, raceRight }
    post(`/official/races/${race.id}/race_rights.json`, body, (errors, response) => {
      if (errors) {
        setFormErrors(errors)
      } else {
        setOfficials(officials => {
          const newOfficials = [...officials, response]
          return newOfficials.sort(officialsSorter)
        })
        setFormErrors(undefined)
        resetPageState()
      }
    })
  }, [race, resetPageState])

  const onAddedMany = useCallback(newOfficials => {
    setOfficials(oldOfficials => {
      const officials = [...oldOfficials, ...newOfficials]
      return officials.sort(officialsSorter)
    })
    resetPageState()
  }, [resetPageState])

  const updateRights = useCallback(data => {
    const raceRight = { onlyAddCompetitors: data.onlyAddCompetitors, newClubs: data.newClubs, clubId: data.clubId }
    const body = { email: data.email, raceRight }
    put(`/official/races/${race.id}/race_rights/${data.id}.json`, body, (errors, response) => {
      if (errors) {
        setFormErrors(errors)
      } else {
        setOfficials(officials => {
          const index = officials.findIndex(o => o.id === data.id)
          const newOfficials = [...officials]
          newOfficials[index] = { ...response }
          return newOfficials.sort(officialsSorter)
        })
        setFormErrors(undefined)
        resetPageState()
      }
    })
  }, [race, resetPageState])

  const deleteRights = useCallback(id => {
    if (confirm('Haluatko varmasti poistaa käyttäjän toimitsijaoikeudet tähän kilpailuun?')) {
      del(`/official/races/${race.id}/race_rights/${id}`, errors => {
        if (errors) {
          console.error(errors[0])
        } else {
          setOfficials(officials => {
            const index = officials.findIndex(o => o.id === id)
            const newOfficials = [...officials]
            newOfficials.splice(index, 1)
            return newOfficials
          })
        }
      })
    }
  }, [race])

  if (!race || !officials) {
    return <IncompletePage fetching={fetching} error={error || officialsError} title="Toimitsijat" />
  }

  if (pageState === pageStates.add) {
    return (
      <div>
        <h2>Kutsu toinen henkilö tämän kilpailun toimitsijaksi</h2>
        <Message type="info">Henkilön täytyy olla rekisteröitynyt palveluun omalla sähköpostiosoitteellaan.</Message>
        <FormErrors errors={formErrors} />
        <OfficialForm
          buttonLabel="Lähetä kutsu"
          onSave={addRights}
          onCancel={resetPageState}
        />
      </div>
    )
  }

  if (pageState === pageStates.addMultiple) {
    return <AddManyOfficialsForm raceId={race.id} onCancel={resetPageState} onSaved={onAddedMany} />
  }

  if (pageState !== pageStates.list) {
    return (
      <div>
        <h2>Muokkaa toimitsijan oikeuksia</h2>
        <FormErrors errors={formErrors} />
        <OfficialForm
          buttonLabel="Päivitä"
          official={pageState}
          onSave={updateRights}
          onCancel={resetPageState}
        />
      </div>
    )
  }

  return (
    <div>
      <h2>Kutsu toinen henkilö tämän kilpailun toimitsijaksi</h2>
      <Message type="info">Henkilön täytyy olla rekisteröitynyt palveluun omalla sähköpostiosoitteellaan.</Message>
      <div className="buttons">
        <Button id="add_button" onClick={() => setPageState(pageStates.add)} type="add">Lisää toimitsija</Button>
        <Button id="add_multiple_button" onClick={() => setPageState(pageStates.addMultiple)} type="add">
          Lisää monta toimitsijaa
        </Button>
      </div>
      <h2>Kilpailun toimitsijat</h2>
      <div id="current_officials" className="row">
        <OfficialsList race={race} officials={officials} onEdit={setPageState} onDelete={deleteRights} />
      </div>
      {race.pendingOfficialEmail && (
        <>
          <h2>Odottaa rekisteröitymistä</h2>
          <div className="row">
            <div className="col-xs-12 col-sm-6">
              <div className="card">
                <div className="card__middle">
                  <div className="card__name">{race.pendingOfficialEmail}</div>
                  <div className="card__middle-row">Täydet oikeudet</div>
                </div>
              </div>
            </div>
          </div>
        </>
      )}
      <div className="buttons buttons--nav">
        <Button href={buildOfficialRacePath(race.id)} type="back">{t('backToOfficialRacePage')}</Button>
      </div>
    </div>
  )
}

export default OfficialsPage
