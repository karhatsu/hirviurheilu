import React from 'react'
import classnames from 'classnames-minimal'
import { Link } from 'react-router'

export default function Button({ children, id, href, onClick, submit, to, type, disabled, blank }) {
  const className = classnames({ button: true, [`button--${type}`]: !!type, 'button--disabled': disabled })
  if (href) {
    const target = blank ? { target: '_blank', rel: 'noreferrer' } : { }
    return <a href={href} className={className} id={id} {...target}>{children}</a>
  } else if (to) {
    return <Link to={to} className={className} id={id}>{children}</Link>
  } else if (submit) {
    return <input type="submit" className={className} id={id} value={children} disabled={disabled} />
  } else {
    return <div onClick={onClick} className={className} id={id}>{children}</div>
  }
}
