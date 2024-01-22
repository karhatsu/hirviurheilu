import React, { useCallback, useState } from 'react'
import Button from '../../common/Button'
import useTranslation from '../../util/useTranslation'
import Message from '../../common/Message'
import FormErrors from '../../common/form/FormErrors'
import { post } from '../../util/apiClient'

const AddManyOfficialsForm = ({ raceId, onCancel, onSaved }) => {
  const { t } = useTranslation()
  const [values, setValues] = useState('')
  const [errors, setErrors] = useState()

  const sendInvitations = useCallback(e => {
    e.preventDefault()
    const body = {
      officials: values.split('\n').map(row => {
        const emailAndClub = row.split(',')
        return { email: emailAndClub[0], club: emailAndClub[1] }
      }).filter(o => o.email),
    }
    post(`/official/races/${raceId}/race_rights/multiple.json`, body, (errors, response) => {
      if (errors) {
        setErrors(errors)
      } else if (response.errors) {
        setErrors(response.errors)
      } else {
        setErrors(undefined)
        onSaved(response.officials)
      }
    })
  }, [raceId, values, onSaved])

  return (
    <div>
      <h2>Kutsu monta toimitsijaa kilpailun toimitsijoiksi</h2>
      <Message type="info">Tällä sivulla voit kutsua monta toimitsijaa kerralla. Listaa toimitsijoiden
        sähköpostiosoitteet ja jos haluat heille rajoitetut oikeudet, lisää perään piiri / seura alla olevan esimerkin
        mukaisesti. Henkilöiden täytyy olla rekisteröitynyt palveluun omilla sähköpostiosoitteillaan.</Message>
      <pre className="file-example">
        toimitsija.1@test.com<br/>
        toimitsija.2@test.com,PS<br/>
        toimitsija.3@test.com,Testikylän metsästysseura
      </pre>
      <FormErrors errors={errors} />
      <form onSubmit={sendInvitations}>
        <div className="form__field">
          <label htmlFor="emails">Sähköpostit ja mahdolliset piirit/seurat</label>
          <textarea id="emails" value={values} onChange={e => setValues(e.target.value)} cols={60} rows={12}/>
        </div>
        <div className="form__buttons">
          <Button submit={true} type="primary">Lähetä kutsut</Button>
        </div>
      </form>
      <div className="buttons buttons--nav">
        <Button onClick={onCancel}>{t('cancel')}</Button>
      </div>
    </div>
  )
}

export default AddManyOfficialsForm
