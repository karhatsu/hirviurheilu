import React from 'react'
import ReactMarkdown from 'react-markdown'
import useTranslation from '../../util/useTranslation'

export default function CupPublicMessage({ cup }) {
  const { t } = useTranslation()
  const { publicMessage } = cup
  if (!publicMessage) return null
  return (
    <>
      <h2>{t('cupPublicMessage')}</h2>
      <div className="public-message">
        <ReactMarkdown>{publicMessage}</ReactMarkdown>
      </div>
    </>
  )
}
