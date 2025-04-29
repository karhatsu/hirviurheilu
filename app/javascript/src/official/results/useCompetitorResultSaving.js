import { useCallback, useEffect, useMemo, useState } from "react"
import { put } from "../../util/apiClient"

const initData = (fields, competitor) => {
  return fields.reduce((acc, field) => {
    const { key, shotCount, value } = field
    const currentValue = competitor[key]
    if (shotCount !== undefined) {
      const length = Math.max(shotCount, currentValue?.length || 0)
      acc[key] = Array.from({ length }, (_, i) => currentValue?.[i] ?? '')
    } else if (value) {
      acc[key] = value
    } else {
      acc[key] = currentValue
    }
    return acc
  }, {})
}

const normalizeValue = value => {
  if (value === '' || value === null) return undefined
  return value
}

const shotsEqual = (array1, array2, shotCount) => {
  for (let i = 0; i < shotCount; i++) {
    if (normalizeValue(array1?.[i]) !== normalizeValue(array2?.[i])) return false
  }
  return true
}

const stringToNumber = fieldValue => (fieldValue === '' ? '' : parseInt(fieldValue))

const useCompetitorResultSaving = (initialCompetitor, fields, buildBody) => {
  const [competitor, setCompetitor] = useState(initialCompetitor)
  const [saving, setSaving] = useState(false)
  const [errors, setErrors] = useState()
  const [saved, setSaved] = useState(false)
  const [data, setData] = useState(() => initData(fields, initialCompetitor))

  useEffect(() => {
    setData(initData(fields, competitor))
  }, [fields, competitor])

  const parseValue = useCallback((fieldKey, event) => {
    const field = fields.find(field => field.key === fieldKey)
    if (field.number) {
      return stringToNumber(event.target.value)
    } else {
      return event.target.value
    }
  }, [fields])

  const onChange = useCallback(fieldKey => event => {
    setSaved(false)
    setErrors(undefined)
    setData(prev => ({ ...prev, [fieldKey]: parseValue(fieldKey, event) }))
  }, [parseValue])

  const onChangeShot = useCallback((fieldKey, index) => event => {
    setSaved(false)
    setErrors(undefined)
    setData(prev => {
      const newData = { ...prev }
      newData[fieldKey] ||= []
      newData[fieldKey][index] = stringToNumber(event.target.value)
      return newData
    })
  }, [])

  const onSubmit = useCallback(event => {
    event.preventDefault()
    setSaving(true)
    setErrors(undefined)
    setSaved(false)
    const body = buildBody ? buildBody(competitor, data) : { competitor: data }
    const path = `/official/races/${competitor.raceId}/series/${competitor.seriesId}/competitors/${competitor.id}.json`
    put(path, body, (err, response) => {
      setSaving(false)
      if (err) {
        setErrors(err)
      } else {
        setCompetitor(response)
        setSaved(true)
      }
    })
  }, [competitor, data, buildBody])

  const changed = useMemo(() => {
    return !!fields.find(field => {
      if (field.value) return false
      const original = competitor[field.key]
      const current = data[field.key]
      if (field.shotCount !== undefined) {
        const count = Math.max(field.shotCount, original?.length || 0, current?.length  || 0)
        return !shotsEqual(original, current, count)
      }
      return normalizeValue(original) !== normalizeValue(current)
    })
  }, [competitor, data, fields])

  return {
    changed,
    competitor,
    data,
    errors,
    onChange,
    onChangeShot,
    onSubmit,
    saved,
    saving,
  }
}

export default useCompetitorResultSaving
