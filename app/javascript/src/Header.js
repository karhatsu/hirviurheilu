import React, { useCallback } from 'react'
import { Link } from 'react-router-dom'

const logo = '/logo-128.png'

export default function Header({ toggleMainMenu }) {
  const toggleMenu = useCallback(e => {
    e.preventDefault()
    toggleMainMenu()
  }, [toggleMainMenu])
  return (
    <div className="header">
      <img alt="Logo" src={logo} className="header__logo" />
      <Link to="/" className="header__title">Hirviurheilu</Link>
      <img alt="Logo" src={logo} className="header__logo header__logo--right" />
      <a className="header__menu material-icons-outlined md-24" href="#" onClick={toggleMenu}>menu</a>
    </div>
  )
}
