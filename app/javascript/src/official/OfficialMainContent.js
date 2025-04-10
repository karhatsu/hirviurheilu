import { Route, Routes } from 'react-router'
import PageTitle from '../common/PageTitle'
import ClubsPage from './clubs/ClubsPage'
import MegalinkImportPage from './megalink/MegalinkImportPage'
import OfficialsPage from './officials/OfficialsPage'
import CompetitorNumbersSyncPage from './events/CompetitorNumbersSyncPage'
import NewEventPage from "./events/NewEventPage"
import EventPage from './events/EventPage'
import EditEventPage from "./events/EditEventPage"
import EventCompetitorsPage from "./events/EventCompetitorsPage"
import PrintsPage from "./events/PrintsPage"
import EstimatesPage from "./results/EstimatesPage"

const OfficialMainContent = () => {
  return (
    <div className="body__yield">
      <div className="body__under-top-title"><PageTitle /></div>
      <Routes>
        <Route path="events" element={null}>
          <Route path="new" element={<NewEventPage />} />
          <Route path=":eventId">
            <Route path="competitor_numbers_sync" element={<CompetitorNumbersSyncPage />} />
            <Route path="competitors" element={<EventCompetitorsPage />} />
            <Route path="edit" element={<EditEventPage />} />
            <Route path="prints" element={<PrintsPage />} />
            <Route path="" element={<EventPage />} />
          </Route>
        </Route>
        <Route path="races/:raceId" element={null}>
          <Route path="clubs" element={<ClubsPage />} />
          <Route path="megalink_imports" element={<MegalinkImportPage />} />
          <Route path="race_rights" element={<OfficialsPage />} />
          <Route path="series/:seriesId" element={null}>
            <Route path="estimates" element={<EstimatesPage />} />
          </Route>
        </Route>
      </Routes>
    </div>
  )
}

export default OfficialMainContent
