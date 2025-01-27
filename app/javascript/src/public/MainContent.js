import React from 'react'
import PageTitle from '../common/PageTitle'
import FacebookShare from './FacebookShare'
import { Route, Routes } from 'react-router-dom'
import TeamCompetitionResultsPage from './team-competition/TeamCompetitionResultsPage'
import QualificationRoundHeats from './heats/QualificationRoundHeats'
import FinalRoundHeats from './heats/FinalRoundHeats'
import ResultRotationPage from './result-rotation/ResultRotationPage'
import StartListPage from './start-list/StartListPage'
import EuropeanRifleSeriesResultsPage from './european/EuropeanRifleSeriesResultsPage'
import SeriesResultsPage from './series-results/SeriesResultsPage'
import RelayResultsPage from './relay/RelayResultsPage'
import RacePressPage from './press/RacePressPage'
import NordicSubSportResultsPage from './nordic/NordicSubSportResultsPage'
import RacePage from './race-page/RacePage'
import CupPressPage from './cup/CupPressPage'
import CupSeriesPage from './cup/CupSeriesPage'
import CupPage from './cup/CupPage'
import AnnouncementPage from './announcements/AnnouncementPage'
import AnnouncementsPage from './announcements/AnnouncementsPage'
import HomePage from './home/HomePage'
import RacesPage from './races/RacesPage'
import InfoPage from './info/InfoPage'
import PricesPage from './info/PricesPage'
import QAndAPage from './info/QAndAPage'
import FeedbackPage from './feedback/FeedbackPage'
import SportsInfoPage from './info/SportsInfoPage'
import CupTeamCompetitionPage from './cup/CupTeamCompetitionPage'
import EuropeanShotgunSeriesResultsPage from './european/EuropeanShotgunSeriesResultsPage'
import EuropeanShotgunRaceResultsPage from './european/EuropeanShotgunRaceResultsPage'
import EuropeanRifleRaceResultsPage from './european/EuropeanRifleRaceResultsPage'

export default function MainContent() {
  return (
    <div className="body__yield">
      <div className="body__under-top-title"><PageTitle /></div>
      <FacebookShare />
      <Routes>
        <Route path="races/*">
          <Route path=":raceId/*">
            <Route path="team_competitions/:teamCompetitionId" element={<TeamCompetitionResultsPage />} />
            <Route path="qualification_round_heats" element={<QualificationRoundHeats />} />
            <Route path="final_round_heats" element={<FinalRoundHeats />} />
            <Route path="result_rotation" element={<ResultRotationPage />} />
            <Route path="series/:seriesId/start_list" element={<StartListPage />} />
            <Route path="series/:seriesId/rifle" element={<EuropeanRifleSeriesResultsPage />} />
            <Route path="series/:seriesId/shotguns" element={<EuropeanShotgunSeriesResultsPage />} />
            <Route path="series/:seriesId/:subSport" element={<NordicSubSportResultsPage />} />
            <Route path="series/:seriesId" element={<SeriesResultsPage />} />
            <Route path="relays/:relayId/legs/:leg" element={<RelayResultsPage />} />
            <Route path="relays/:relayId" element={<RelayResultsPage />} />
            <Route path="press" element={<RacePressPage />} />
            <Route path="rifle" element={<EuropeanRifleRaceResultsPage />} />
            <Route path="shotguns" element={<EuropeanShotgunRaceResultsPage />} />
            <Route path=":subSport" element={<NordicSubSportResultsPage />} />
            <Route
              path="rifle_team_competitions/:teamCompetitionId"
              element={<TeamCompetitionResultsPage rifle={true} />}
            />
            <Route path="" element={<RacePage />} />
          </Route>
          <Route path="" element={<RacesPage />} />
        </Route>
        <Route path="cups/:cupId/*">
          <Route path="press" element={<CupPressPage />} />
          <Route path="cup_series/:cupSeriesId" element={<CupSeriesPage />} />
          <Route path="rifle_cup_series/:rifleCupSeriesId" element={<CupSeriesPage />} />
          <Route path="cup_team_competitions/:cupTeamCompetitionId" element={<CupTeamCompetitionPage />} />
          <Route path="" element={<CupPage />} />
        </Route>
        <Route path="announcements/*">
          <Route path=":announcementId" element={<AnnouncementPage />} />
          <Route path="" element={<AnnouncementsPage />} />
        </Route>
        <Route path="info" element={<InfoPage />} />
        <Route path="prices" element={<PricesPage />} />
        <Route path="answers" element={<QAndAPage />} />
        <Route path="sports_info" element={<SportsInfoPage />} />
        <Route path="feedbacks/new" element={<FeedbackPage />} />
        <Route path="" element={<HomePage />} />
      </Routes>
    </div>
  )
}
