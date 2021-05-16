import React from 'react'
import { BrowserRouter, Route } from 'react-router-dom'
import StartList from './public/StartList'

export default function App() {
  return (
    <BrowserRouter>
      <Route path="/races/:raceId/series/:seriesId/start_list" component={StartList} />
    </BrowserRouter>
  )
}
