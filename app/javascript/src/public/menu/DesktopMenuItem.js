import React from 'react'
import { Link } from 'react-router-dom'

export default function DesktopMenuItem({ path, text, reactLink, selected, dropdownItems, dropdownMinCount, onClick }) {
  const renderLink = (path, text, isSelected) => {
    const className = isSelected ? 'selected' : ''
    if (reactLink) {
      return <Link className={className} to={path} onClick={onClick}>{text}</Link>
    } else {
      return <a className={className} href={path}>{text}</a>
    }
  }

  return (
    <div className="menu__item">
      {renderLink(path, text, selected)}
      {dropdownItems && dropdownItems.length >= (dropdownMinCount || 2) && (
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
