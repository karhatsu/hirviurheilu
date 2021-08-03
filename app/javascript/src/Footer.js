import React from 'react'
import getYear from 'date-fns/getYear'
import useTranslation from './util/useTranslation'

export default function Footer() {
  const { t } = useTranslation()
  return (
    <div className="footer">
      &copy; 2010-{getYear(new Date())}{' '}
      <a href="https://www.karhatsu.com" target="_blank" rel="noreferrer">Karhatsu IT Consulting Oy</a>
      {' - '}
      <a href="/feedbacks/new">{t('sendFeedback')}</a>
    </div>
  )
}
