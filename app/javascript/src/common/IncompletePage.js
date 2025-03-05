import Spinner from './Spinner'
import Message from './Message'

export default function IncompletePage({ fetching, error, title }) {
  return (
    <div className="incomplete-page">
      {title && <h2>{title}</h2>}
      {fetching && <Spinner />}
      {!fetching && error && <Message type="error">{error}</Message>}
    </div>
  )
}
