import format from 'date-fns/format'
import ReactMarkdown from 'react-markdown'

export default function Announcement({ announcement }) {
  const { title, published, markdown } = announcement
  return (
    <div className="announcement">
      <h2>
        {format(new Date(published), 'dd.MM.yyyy')} - {title}
      </h2>
      <ReactMarkdown>{markdown}</ReactMarkdown>
    </div>
  )
}
