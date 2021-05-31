import React from 'react'
import useTranslation from '../../util/useTranslation'

export default function UnofficialLabel({ unofficial }) {
  const { t } = useTranslation()
  if (!unofficial) return null
  return (
    <span className="unofficial" title={t('unofficialCompetitor')}>{t('unofficialShort')}</span>
  )
}
