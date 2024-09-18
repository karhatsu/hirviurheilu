import React, { useCallback, useEffect, useState } from 'react'
import useOfficialMenu from '../menu/useOfficialMenu'
import Message from '../../common/Message'
import { useRace } from '../../util/useRace'
import { del, get, post, put } from '../../util/apiClient'
import IncompletePage from '../../common/IncompletePage'
import useTranslation from '../../util/useTranslation'
import { buildOfficialRacePath, withLocale } from '../../util/routeUtil'
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
      get(withLocale(`/official/races/${race.id}/race_rights.json`), (err, response) => {
        if (err) setOfficialsError(err[0])
        else setOfficials(response.officials.sort(officialsSorter))
      })
    }
  }, [race])

  const resetPageState = useCallback(() => setPageState(pageStates.list), [])

  const addRights = useCallback(data => {
    const raceRight = { onlyAddCompetitors: data.onlyAddCompetitors, newClubs: data.newClubs, clubId: data.clubId }
    const body = { email: data.email, race_right: raceRight }
    post(withLocale(`/official/races/${race.id}/race_rights.json`), body, (errors, response) => {
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
    const body = { email: data.email, race_right: raceRight }
    put(withLocale(`/official/races/${race.id}/race_rights/${data.id}.json`), body, (errors, response) => {
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
    if (confirm(t('officialPageDeleteRightsConfirmation'))) {
      del(withLocale(`/official/races/${race.id}/race_rights/${id}`), errors => {
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
  }, [race, t])

  if (!race || !officials) {
    return <IncompletePage fetching={fetching} error={error || officialsError} title={t('officialRaceMenuOfficials')} />
  }

  if (pageState === pageStates.add) {
    return (
      <div>
        <h2>{t('officialPageInvite')}</h2>
        <Message type="info">{t('officialPageRequirement')}</Message>
        <FormErrors errors={formErrors} />
        <OfficialForm
          buttonLabel={t('officialPageSendInvitation')}
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
        <h2>{t('editOfficialRights')}</h2>
        <FormErrors errors={formErrors} />
        <OfficialForm
          buttonLabel={t('update')}
          official={pageState}
          onSave={updateRights}
          onCancel={resetPageState}
        />
      </div>
    )
  }

  return (
    <div>
      <h2>{t('officialPageInvite')}</h2>
      <Message type="info">{t('officialPageRequirement')}</Message>
      <div className="buttons">
        <Button id="add_button" onClick={() => setPageState(pageStates.add)} type="add">{t('addOfficial')}</Button>
        <Button id="add_multiple_button" onClick={() => setPageState(pageStates.addMultiple)} type="add">
          {t('addManyOfficials')}
        </Button>
      </div>
      <h2>{t('officialPageRaceOfficials')}</h2>
      <div id="current_officials" className="row">
        <OfficialsList race={race} officials={officials} onEdit={setPageState} onDelete={deleteRights} />
      </div>
      {race.pendingOfficialEmail && (
        <>
          <h2>{t('officialPagePendingInvites')}</h2>
          <div className="row">
            <div className="col-xs-12 col-sm-6">
              <div className="card">
                <div className="card__middle">
                  <div className="card__name">{race.pendingOfficialEmail}</div>
                  <div className="card__middle-row">{t('officialPageFullRights')}</div>
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
