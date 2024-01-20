import React from 'react'
import { Route, Switch } from 'react-router-dom'
import PageTitle from '../common/PageTitle'
import ClubsPage from './clubs/ClubsPage'
import MegalinkImportPage from './megalink/MegalinkImportPage'
import OfficialsPage from './officials/OfficialsPage'

const OfficialMainContent = () => {
  return (
    <div className="body__yield">
      <div className="body__under-top-title"><PageTitle /></div>
      <Switch exact>
        <Route path="/:lang?/official/races/:raceId/clubs" component={ClubsPage} />
        <Route path="/:lang?/official/races/:raceId/megalink_imports" component={MegalinkImportPage} />
        <Route path="/:lang?/official/races/:raceId/race_rights" component={OfficialsPage} />
      </Switch>
    </div>
  )
}

export default OfficialMainContent
