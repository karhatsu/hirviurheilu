import { Route, Routes } from 'react-router'
import PageTitle from '../common/PageTitle'
import ClubsPage from './clubs/ClubsPage'
import MegalinkImportPage from './megalink/MegalinkImportPage'
import OfficialsPage from './officials/OfficialsPage'
import CompetitorNumbersSyncPage from './events/CompetitorNumbersSyncPage'
import NewEventPage from './events/NewEventPage'
import EventPage from './events/EventPage'
import EditEventPage from './events/EditEventPage'
import EventCompetitorsPage from './events/EventCompetitorsPage'
import PrintsPage from './events/PrintsPage'
import EstimatesPage from './results/EstimatesPage'
import TimesPage from './results/TimesPage'
import ShotsPage from './results/ShotsPage'
import NordicShotsPage from './results/NordicShotsPage'
import EuropeanShotsPage from './results/EuropeanShotsPage'
import ShootingByHeatsPage from './results/ShootingByHeatsPage'
import NewCompetitorPage from './competitors/NewCompetitorPage'
import EditCompetitorPage from './competitors/EditCompetitorPage'
import StartListPage from './start-list/StartListPage'
import LimitedNewCompetitorPage from './limited/LimitedNewCompetitorPage'
import LimitedEditCompetitorPage from './limited/LimitedEditCompetitorPage'

const OfficialMainContent = () => {
  return (
    <div className="body__yield">
      <div className="body__under-top-title">
        <PageTitle />
      </div>
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
          <Route path="european_compak" element={<EuropeanShotsPage subSport="compak" />} />
          <Route path="european_rifle" element={<EuropeanShotsPage subSport="rifle" />} />
          <Route path="european_trap" element={<EuropeanShotsPage subSport="trap" />} />
          <Route path="megalink_imports" element={<MegalinkImportPage />} />
          <Route path="nordic_shotgun" element={<NordicShotsPage subSport="shotgun" />} />
          <Route path="nordic_trap" element={<NordicShotsPage subSport="trap" />} />
          <Route path="nordic_rifle_moving" element={<NordicShotsPage subSport="rifleMoving" />} />
          <Route path="nordic_rifle_standing" element={<NordicShotsPage subSport="rifleStanding" />} />
          <Route path="race_rights" element={<OfficialsPage />} />
          <Route path="series/:seriesId" element={null}>
            <Route path="competitors" element={null}>
              <Route path="new" element={<NewCompetitorPage />} />
              <Route path=":competitorId/edit" element={<EditCompetitorPage />} />
            </Route>
            <Route path="estimates" element={<EstimatesPage />} />
            <Route path="times" element={<TimesPage />} />
            <Route path="shots" element={<ShotsPage />} />
          </Route>
          <Route path="shooting_by_heats" element={<ShootingByHeatsPage />} />
          <Route path="start_list" element={<StartListPage />} />
        </Route>
        <Route path="limited/races/:raceId" element={null}>
          <Route path="competitors/new" element={<LimitedNewCompetitorPage />} />
          <Route path="competitors/:competitorId/edit" element={<LimitedEditCompetitorPage />} />
        </Route>
      </Routes>
    </div>
  )
}

export default OfficialMainContent
