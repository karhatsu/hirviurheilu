import React from 'react'
import useTranslation from '../util/useTranslation'
import { buildCupPath } from '../util/routeUtil'

export default function RaceCups({ race }) {
  const { t } = useTranslation()
  const { cups } = race
  if (!cups.length) return null
  return (
    <>
      <h2>{t('cups')}</h2>
      <div className="buttons">
        {cups.map(cup => {
          const { id, name } = cup
          return <a key={id} href={buildCupPath(id)} className="button">{name}</a>
        })}
      </div>
    </>
  )
}
