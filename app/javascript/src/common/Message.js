import classnames from 'classnames-minimal'

export default function Message({ children, type, inline }) {
  const className = classnames({ message: true, [`message--${type}`]: !!type, ['message--inline']: inline })
  return <div className={className}>{children}</div>
}
