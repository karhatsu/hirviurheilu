import React, { useCallback, useEffect, useState } from 'react'
import { get } from '../../util/apiClient'
import { useRace } from '../../util/useRace'
import Button from '../../common/Button'
import { buildOfficialRaceClubsPath } from '../../util/routeUtil'
import { Link } from 'react-router-dom'
import useTranslation from '../../util/useTranslation'

const newOfficial = { email: '', onlyAddCompetitors: false, newClubs: false, clubId: null }

const OfficialForm = ({ official, onSave, onCancel, buttonLabel }) => {
  const { t } = useTranslation()
  const [data, setData] = useState(official || newOfficial)
  const [clubs, setClubs] = useState([])
  const { race } = useRace()

  useEffect(() => {
    if (race) {
      get(`/official/races/${race.id}/clubs.json`, (err, response) => {
        if (err) console.error(err)
        else setClubs(response.clubs)
      })
    }
  }, [race])

  const setValue = useCallback((key, checkbox) => event => {
    const value = checkbox ? event.target.checked : event.target.value
    setData(prev => {
      const newData = { ...prev, [key]: value }
      if (key === 'onlyAddCompetitors' && !value) {
        newData.newClubs = false
        newData.clubId = null
      } else if (key === 'newClubs' && value) {
        newData.clubId = null
      }
      return newData
    })
  }, [])

  const onSubmit = useCallback(event => {
    event.preventDefault()
    onSave(data)
  }, [onSave, data])

  return (
    <div>
      <form className="form" onSubmit={onSubmit}>
        <div className="form__field">
          <label htmlFor="email">Sähköposti</label>
          <input id="email" type="email" value={data.email} onChange={setValue('email')} />
        </div>
        <div className="form__field">
          <label htmlFor="onlyAddCompetitors">Anna käyttäjälle ainoastaan oikeudet lisätä kilpailijoita</label>
          <input
            id="onlyAddCompetitors"
            type="checkbox"
            checked={data.onlyAddCompetitors}
            onChange={setValue('onlyAddCompetitors', true)}
          />
        </div>
        {data.onlyAddCompetitors && (
          <>
            <div className="form__field">
              <label htmlFor="newClubs">Salli uusien piirien/seurojen lisäys</label>
              <input id="newClubs" type="checkbox" checked={data.newClubs} onChange={setValue('newClubs', true)} />
            </div>
            {!data.newClubs && (
              <>
                <div className="form__field">
                  <label htmlFor="clubId">Salli kilpailijoiden lisäys vain tiettyyn piiriin/seuraan</label>
                  {!clubs.length && (
                    <div>
                      (Käyttöä ei voi rajata, koska{' '}
                      <Link to={buildOfficialRaceClubsPath(race.id)}>yhtään piiriä/seuraa ei ole lisätty</Link>.)
                    </div>
                  )}
                  {clubs.length > 0 && (
                    <select id="clubId" value={data.clubId || ''} onChange={setValue('clubId')}>
                      <option>Ei rajausta</option>
                      {clubs.map(club => <option key={club.id} value={club.id}>{club.name}</option>)}
                    </select>
                  )}
                </div>
              </>
            )}
          </>
        )}
        <div className="form__buttons">
          <Button submit={true} type="primary">{buttonLabel}</Button>
        </div>
      </form>
      <div className="buttons buttons--nav">
        <Button onClick={onCancel}>{t('cancel')}</Button>
      </div>
    </div>
  )
}

export default OfficialForm
