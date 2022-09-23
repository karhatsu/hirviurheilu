import React from 'react'

const FormErrors = ({ errors }) => {
  if (!errors || !errors.length) return null
  return (
    <div className="message message--error">
      <ul>
        {errors.map((error, i) => <li key={i}>{error}</li>)}
      </ul>
    </div>
  )
}

export default FormErrors
