import React from 'react'
import classnames from 'classnames-minimal'

export default function Message({ children, type }) {
  const className = classnames({ message: true, [`message--${type}`]: !!type })
  return <div className={className}>{children}</div>
}
