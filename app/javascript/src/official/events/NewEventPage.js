import React from 'react'
import useTitle from "../../util/useTitle"
import useTranslation from "../../util/useTranslation"

const NewEventPage = () => {
  const { t } = useTranslation()
  useTitle(t('eventsNew'))
  return <div>TODO</div>
}

export default NewEventPage
