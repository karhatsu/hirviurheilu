import React from 'react'
import { Route, Switch } from 'react-router-dom'
import PageTitle from '../common/PageTitle'
import ClubsPage from './clubs/ClubsPage'

const OfficialMainContent = () => {
  return (
    <div className="body__yield">
      <div className="body__under-top-title"><PageTitle /></div>
      <Switch exact>
        <Route path="/:lang?/official/races/:raceId/clubs" component={ClubsPage} />
      </Switch>
    </div>
  )
}

export default OfficialMainContent
