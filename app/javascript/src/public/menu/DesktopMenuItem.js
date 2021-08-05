import React from 'react'
import { Link } from 'react-router-dom'

export default function DesktopMenuItem(props) {
  const { path, text, reactLink, selected, dropdownItems, dropdownMinCount, onClick, icon } = props
  const renderLink = (path, text, isSelected, icon) => {
    const className = isSelected ? 'selected' : ''
    const iconElem = icon && <i className="material-icons-outlined md-18">{icon}</i>
    if (reactLink) {
      return <Link className={className} to={path} onClick={onClick}>{iconElem}{text}</Link>
    } else {
      return <a className={className} href={path}>{iconElem}{text}</a>
    }
  }

  return (
    <div className="menu__item">
      {renderLink(path, text, selected, icon)}
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
