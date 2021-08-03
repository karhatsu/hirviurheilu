import React from 'react'
import format from 'date-fns/format'

export default function Announcement({ announcement }) {
  const { title, published, content } = announcement
  return (
    <>
      <h2>{format(new Date(published), 'dd.MM.yyyy')} - {title}</h2>
      <div dangerouslySetInnerHTML={{ __html: content }}/>
    </>
  )
}
