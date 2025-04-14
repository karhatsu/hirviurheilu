import { useCallback, useMemo, useState } from "react"
import { put } from "../../util/apiClient"

const useCompetitorResultSaving = (initialCompetitor, fields, buildBody) => {
  const [competitor, setCompetitor] = useState(initialCompetitor)
  const [saving, setSaving] = useState(false)
  const [errors, setErrors] = useState()
  const [saved, setSaved] = useState(false)
  const [data, setData] = useState(() => {
    return fields.reduce((acc, field) => {
      acc[field] = initialCompetitor[field]
      return acc
    }, {})
  })

  const onChange = useCallback((field, value) => {
    setSaved(false)
    setErrors(undefined)
    setData(prev => ({ ...prev, [field]: value }))
  }, [])

  const onSubmit = useCallback(event => {
    event.preventDefault()
    setSaving(true)
    setErrors(undefined)
    setSaved(false)
    const body = buildBody ? buildBody(competitor, data) : { competitor: data }
    const path = `/official/series/${competitor.seriesId}/competitors/${competitor.id}.json`
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
    return !!fields.find(field => competitor[field] !== data[field])
  }, [competitor, data, fields])

  return {
    changed,
    competitor,
    data,
    errors,
    onChange,
    onSubmit,
    saved,
    saving,
  }
}

export default useCompetitorResultSaving
