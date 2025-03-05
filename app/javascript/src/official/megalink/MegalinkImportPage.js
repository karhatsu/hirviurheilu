import { useCallback, useState } from 'react'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'
import { post } from '../../util/apiClient'
import { useRace } from '../../util/useRace'
import IncompletePage from '../../common/IncompletePage'
import FormErrors from '../../common/form/FormErrors'
import Message from '../../common/Message'
import { buildOfficialRacePath } from '../../util/routeUtil'

const pickShots = series => {
  const shots = []
  series.forEach(ser => {
    ser.Shots.forEach(shot => {
      if (shot.Vd >= 10.4) {
        shots.push(11)
      } else {
        shots.push(parseInt(shot.Vm))
      }
    })
  })
  return shots
}

const readResults = json => {
  const results = []
  json.Event[0].Relay[0].Score.forEach(score => {
    const shots = pickShots(score.Series)
    results.push({ place: parseInt(score.FP), shots })
  })
  return results
}

const readHeatNumber = json => json.Event[0].Relay[0].Rel

const rounds = { qualification: 'qr', final: 'final' }

const isValidJson = contents => {
  try {
    return contents && !!JSON.parse(contents)
  } catch {
    return false
  }
}

const MegalinkImportPage = () => {
  const { fetching, error: raceError, race } = useRace()
  const [round, setRound] = useState()
  const [file, setFile] = useState('')
  const [errors, setErrors] = useState([])
  const [success, setSuccess] = useState(false)
  const { t } = useTranslation()

  const onFileChange = useCallback(event => {
    setErrors([])
    setFile(event.target.value)
  }, [])

  const onSubmit = useCallback((event, json, round) => {
    event.preventDefault()
    setErrors([])
    setSuccess(false)
    let heatNumber
    let results
    try {
      heatNumber = readHeatNumber(json)
      results = readResults(json)
    } catch {
      setErrors([t('megaLinkImportContentsError')])
      return
    }
    const path = round === rounds.final ? 'final_round_heat_results' : 'qualification_round_heat_results'
    post(`/official/races/${race.id}/${path}/${heatNumber}`, { results }, errors => {
      if (errors) {
        setErrors(errors)
      } else {
        setSuccess(true)
        setRound()
        setFile('')
        setTimeout(() => setSuccess(false), 3000)
      }
    })
  }, [race, t])

  if (!race || fetching) {
    return <IncompletePage title={t('megaLinkImportTitle')} error={raceError} fetching={fetching} />
  }

  const createRadio = r => <input type="radio" id={r} checked={round === r} onChange={() => setRound(r)} />
  return (
    <div>
      <h2>{t('megaLinkImportTitle')}</h2>
      <form className="form" onSubmit={e => onSubmit(e, JSON.parse(file), round)}>
        <div className="form__horizontal-fields">
          <div className="form__field">
            {createRadio(rounds.qualification)}
            <label htmlFor={rounds.qualification}>{t('qualificationRound')}</label>
            {createRadio(rounds.final)}
            <label htmlFor={rounds.final}>{t('finalRound')}</label>
          </div>
        </div>
        <div className="form__field">
          <label htmlFor="file">{t('megaLinkImportFile')}</label>
          <textarea id="file" value={file} onChange={onFileChange} cols={60} rows={12} />
        </div>
        <FormErrors errors={errors} />
        {success && <Message type="success">{t('megaLinkImportSuccess')}</Message>}
        <div className="form__buttons">
          <Button type="primary" submit disabled={!round || !isValidJson(file)}>{t('save')}</Button>
        </div>
      </form>
      <div className="buttons buttons--nav">
        <Button href={buildOfficialRacePath(race.id)} type="back">{t('backToOfficialRacePage')}</Button>
      </div>
    </div>
  )
}

export default MegalinkImportPage
