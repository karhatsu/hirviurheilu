import React from 'react'
import { Link } from 'react-router-dom'
import getYear from 'date-fns/getYear'
import useTranslation from './util/useTranslation'
import { buildFeedbackPath } from './util/routeUtil'

export default function Footer() {
  const { t } = useTranslation()
  return (
    <div className="footer">
      &copy; 2010-{getYear(new Date())}{' '}
      <a href="https://www.karhatsu.com" target="_blank" rel="noreferrer">Karhatsu IT Consulting Oy</a>
      {' - '}
      <Link to={buildFeedbackPath()}>{t('sendFeedback')}</Link>
    </div>
  )
}
