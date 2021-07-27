import React from 'react'
import useTranslation from '../../util/useTranslation'
import { buildCupPath } from '../../util/routeUtil'
import Button from '../../common/Button'

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
          return <Button key={id} to={buildCupPath(id)}>{name}</Button>
        })}
      </div>
    </>
  )
}
