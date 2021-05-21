import React from 'react'
import { Link } from 'react-router-dom'

export default function DesktopMenuItem({ path, text, reactLink, selected, dropdownItems }) {
  const renderLink = (path, text, selected) => {
    const className = selected ? 'selected' : ''
    if (reactLink) {
      return <Link className={className} to={path}>{text}</Link>
    } else {
      return <a className={className} href={path}>{text}</a>
    }
  }

  return (
    <div className="menu__item">
      {renderLink(path, text, selected)}
      {dropdownItems && dropdownItems.length > 1 && (
        <div className="dropdown-menu">
          {dropdownItems.map(dropdownItem => {
            const { text, path } = dropdownItem
            return (
              <div className="dropdown-menu__item" key={text}>{renderLink(path, text)}</div>
            )
          })}
        </div>
      )}
    </div>
  )
}
