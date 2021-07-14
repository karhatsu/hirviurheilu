import React from 'react'
import classnames from 'classnames-minimal'
import { Link } from 'react-router-dom'

export default function Button({ children, id, href, onClick, submit, to, type }) {
  const className = classnames({ button: true, [`button--${type}`]: !!type })
  if (href) {
    return <a href={href} className={className} id={id}>{children}</a>
  } else if (to) {
    return <Link to={to} className={className} id={id}>{children}</Link>
  } else if (submit) {
    return <input type="submit" className={className} id={id} value={children} />
  } else {
    return <div onClick={onClick} className={className} id={id}>{children}</div>
  }
}
