import React from 'react'
import PageTitle from '../common/PageTitle'
import FacebookShare from './FacebookShare'
import { Route, Switch } from 'react-router-dom'
import TeamCompetitionResultsPage from './team-competition/TeamCompetitionResultsPage'
import QualificationRoundBatches from './batches/QualificationRoundBatches'
import FinalRoundBatches from './batches/FinalRoundBatches'
import ResultRotationPage from './result-rotation/ResultRotationPage'
import StartListPage from './start-list/StartListPage'
import EuropeanRifleResultsPage from './european/EuropeanRifleResultsPage'
import SeriesResultsPage from './series-results/SeriesResultsPage'
import RelayResultsPage from './relay/RelayResultsPage'
import RaceMediaPage from './media/RaceMediaPage'
import NordicSubSportResultsPage from './nordic/NordicSubSportResultsPage'
import RacePage from './race-page/RacePage'
import CupMediaPage from './cup/CupMediaPage'
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

export default function MainContent({ cupSeriesPaths }) {
  return (
    <div className="body__yield">
      <div className="body__under-top-title"><PageTitle /></div>
      <FacebookShare />
      <Switch exact>
        <Route
          path="/:lang?/races/:raceId/rifle_team_competitions/:teamCompetitionId"
          render={() => <TeamCompetitionResultsPage rifle={true} />}
        />
        <Route
          path="/:lang?/races/:raceId/team_competitions/:teamCompetitionId"
          render={() => <TeamCompetitionResultsPage />}
        />
        <Route
          path="/:lang?/races/:raceId/qualification_round_batches"
          render={() => <QualificationRoundBatches />}
        />
        <Route
          path="/:lang?/races/:raceId/final_round_batches"
          render={() => <FinalRoundBatches />}
        />
        <Route
          path="/:lang?/races/:raceId/result_rotation"
          render={() => <ResultRotationPage />}
        />
        <Route
          path="/:lang?/races/:raceId/series/:seriesId/start_list"
          render={() => <StartListPage />}
        />
        <Route
          path="/:lang?/races/:raceId/series/:seriesId/rifle"
          render={() => <EuropeanRifleResultsPage />}
        />
        <Route
          path="/:lang?/races/:raceId/series/:seriesId/:subSport"
          render={() => <NordicSubSportResultsPage />}
        />
        <Route
          path="/:lang?/races/:raceId/series/:seriesId"
          render={() => <SeriesResultsPage />}
        />
        <Route
          path={['/:lang?/races/:raceId/relays/:relayId/legs/:leg', '/:lang?/races/:raceId/relays/:relayId']}
          render={() => <RelayResultsPage />}
        />
        <Route
          path="/:lang?/races/:raceId/medium/new"
          render={() => <RaceMediaPage />}
        />
        <Route
          path="/:lang?/races/:raceId/:subSport"
          render={() => <NordicSubSportResultsPage />}
        />
        <Route path="/:lang?/races/:raceId" render={() => <RacePage />} />
        <Route path="/:lang?/races" component={RacesPage} />
        <Route
          path="/:lang?/cups/:cupId/medium/new"
          render={() => <CupMediaPage />}
        />
        <Route path={cupSeriesPaths} render={() => <CupSeriesPage />} />
        <Route
          path="/:lang?/cups/:cupId/cup_team_competitions/:cupTeamCompetitionId"
          component={CupTeamCompetitionPage}
        />
        <Route path="/:lang?/cups/:cupId" render={() => <CupPage />} />
        <Route path="/:lang?/announcements/:announcementId" component={AnnouncementPage} />
        <Route path="/:lang?/announcements" component={AnnouncementsPage} />
        <Route path="/:lang?/info" render={() => <InfoPage />} />
        <Route path="/:lang?/prices" render={() => <PricesPage />} />
        <Route path="/:lang?/answers" render={() => <QAndAPage />} />
        <Route path="/:lang?/sports_info" render={() => <SportsInfoPage />} />
        <Route path="/:lang?/feedbacks/new" render={() => <FeedbackPage />} />
        <Route path="/:lang?" component={HomePage} />
      </Switch>
    </div>
  )
}
