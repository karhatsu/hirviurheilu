import React from 'react'
import useLayout from '../../util/useLayout'
import Button from '../../common/Button'

export default function MobileSubMenu({ items, currentId, buildPath, parentId }) {
  const { mobile } = useLayout()
  if (!mobile || items.length < 2) return null
  return (
    <div className="buttons buttons--mobile">
      {items.map(item => {
        const { id, name } = item
        if (parseInt(currentId) === id) {
          return <Button key={id} type="current">{name}</Button>
        }
        return <Button key={id} to={buildPath(parentId, id)}>{name}</Button>
      })}
    </div>
  )
}
