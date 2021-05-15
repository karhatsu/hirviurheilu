import React from 'react'
import ReactDOM from 'react-dom'
import App from '../src/app'

document.addEventListener('DOMContentLoaded', () => {
  const appElement = document.getElementById('react-app')
  if (appElement) {
    ReactDOM.render(<App />, appElement)
  }
})
