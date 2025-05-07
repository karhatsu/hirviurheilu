import { useCallback, useEffect, useMemo, useState } from 'react'
import { post, put } from '../../util/apiClient'

const initData = (fields, competitor) => {
  return fields.reduce((acc, field) => {
    const { checkbox, key, shotCount, value } = field
    const currentValue = competitor[key]
    if (shotCount !== undefined) {
      const length = Math.max(shotCount, currentValue?.length || 0)
      acc[key] = Array.from({ length }, (_, i) => currentValue?.[i] ?? '')
    } else if (value) {
      acc[key] = value
    } else if (checkbox) {
      acc[key] = currentValue || false
    } else {
      acc[key] = currentValue || ''
    }
    return acc
  }, {})
}

const normalizeValue = (value) => {
  if (value === '' || value === null) return undefined
  return value
}

const shotsEqual = (array1, array2, shotCount) => {
  for (let i = 0; i < shotCount; i++) {
    if (normalizeValue(array1?.[i]) !== normalizeValue(array2?.[i])) return false
  }
  return true
}

const stringToNumber = (fieldValue) => (fieldValue === '' ? '' : parseInt(fieldValue))

const useCompetitorSaving = (raceId, initialCompetitor, fields, buildBody, onSave) => {
  const [competitor, setCompetitor] = useState(initialCompetitor)
  const [saving, setSaving] = useState(false)
  const [errors, setErrors] = useState()
  const [saved, setSaved] = useState(false)
  const [data, setData] = useState(() => initData(fields, initialCompetitor))

  useEffect(() => {
    setData(initData(fields, competitor))
  }, [fields, competitor])

  const parseValue = useCallback(
    (fieldKey, event) => {
      const field = fields.find((field) => field.key === fieldKey)
      if (field.number) {
        return stringToNumber(event.target.value)
      } else if (field.checkbox) {
        return event.target.checked
      } else {
        return event.target.value
      }
    },
    [fields],
  )

  const onChange = useCallback(
    (fieldKey) => (event) => {
      setSaved(false)
      setErrors(undefined)
      setData((prev) => ({ ...prev, [fieldKey]: parseValue(fieldKey, event) }))
    },
    [parseValue],
  )

  const changeValue = useCallback((fieldKey, value) => {
    setSaved(false)
    setErrors(undefined)
    setData((prev) => ({ ...prev, [fieldKey]: value }))
  }, [])

  const onChangeShot = useCallback(
    (fieldKey, index) => (event) => {
      setSaved(false)
      setErrors(undefined)
      setData((prev) => {
        const newData = { ...prev }
        newData[fieldKey] = prev[fieldKey] ? [...prev[fieldKey]] : []
        newData[fieldKey][index] = stringToNumber(event.target.value)
        return newData
      })
    },
    [],
  )

  const resolveApiPath = useCallback(() => {
    if (competitor.id) {
      return `/official/races/${raceId}/series/${competitor.seriesId}/competitors/${competitor.id}.json`
    }
    return `/official/races/${raceId}/competitors.json`
  }, [raceId, competitor])

  const onSubmit = useCallback(
    (event) => {
      event.preventDefault()
      setSaving(true)
      setErrors(undefined)
      setSaved(false)
      const isEditing = !!competitor.id
      const body = buildBody ? buildBody(competitor, data) : { competitor: data }
      const method = isEditing ? put : post
      method(resolveApiPath(), body, (err, response) => {
        setSaving(false)
        if (err) {
          setErrors(err)
        } else {
          setSaved(true)
          onSave && onSave(response)
          if (isEditing) {
            setCompetitor(response)
          } else {
            setCompetitor({
              seriesId: response.seriesId,
              ageGroupId: response.ageGroupId,
              number: response.nextNumber,
              startTime: response.nextStartTime,
            })
          }
        }
      })
    },
    [resolveApiPath, competitor, data, buildBody, onSave],
  )

  const changed = useMemo(() => {
    return !!fields.find((field) => {
      if (field.value) return false
      const original = competitor[field.key]
      const current = data[field.key]
      if (field.shotCount !== undefined) {
        const count = Math.max(field.shotCount, original?.length || 0, current?.length || 0)
        return !shotsEqual(original, current, count)
      }
      return normalizeValue(original) !== normalizeValue(current)
    })
  }, [competitor, data, fields])

  return {
    changed,
    changeValue,
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

export default useCompetitorSaving
