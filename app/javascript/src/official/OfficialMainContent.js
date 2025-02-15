import React from 'react'
import { Route, Routes } from 'react-router'
import PageTitle from '../common/PageTitle'
import ClubsPage from './clubs/ClubsPage'
import MegalinkImportPage from './megalink/MegalinkImportPage'
import OfficialsPage from './officials/OfficialsPage'
import CompetitorNumbersSyncPage from './competitor_numbers_sync/CompetitorNumbersSyncPage'
import NewEventPage from "./events/NewEventPage"
import EventPage from './events/EventPage'
import EditEventPage from "./events/EditEventPage"

const OfficialMainContent = () => {
  return (
    <div className="body__yield">
      <div className="body__under-top-title"><PageTitle /></div>
      <Routes>
        <Route path="competitor_number_syncs" element={<CompetitorNumbersSyncPage />} />
        <Route path="events" element={null}>
          <Route path="new" element={<NewEventPage />} />
          <Route path=":eventId">
            <Route path="edit" element={<EditEventPage />} />
            <Route path="" element={<EventPage />} />
          </Route>
        </Route>
        <Route path="races/:raceId" element={null}>
          <Route path="clubs" element={<ClubsPage />} />
          <Route path="megalink_imports" element={<MegalinkImportPage />} />
          <Route path="race_rights" element={<OfficialsPage />} />
        </Route>
      </Routes>
    </div>
  )
}

export default OfficialMainContent
