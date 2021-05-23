import React from 'react'
import ReactMarkdown from 'react-markdown'
import useTranslation from '../util/useTranslation'

export default function RacePublicMessage({ race }) {
  const { t } = useTranslation()
  const { publicMessage } = race
  if (!publicMessage) return null
  return (
    <>
      <h2>{t('racePublicMessage')}</h2>
      <div className="public-message">
        <ReactMarkdown>{publicMessage}</ReactMarkdown>
      </div>
    </>
  )
}
