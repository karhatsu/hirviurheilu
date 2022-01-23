import React from 'react'
import PageTitle from './PageTitle'
import FacebookShare from './public/FacebookShare'
import { Route, Switch } from 'react-router-dom'
import TeamCompetitionResultsPage from './public/team-competition/TeamCompetitionResultsPage'
import QualificationRoundBatches from './public/batches/QualificationRoundBatches'
import FinalRoundBatches from './public/batches/FinalRoundBatches'
import ResultRotationPage from './public/result-rotation/ResultRotationPage'
import StartListPage from './public/start-list/StartListPage'
import EuropeanRifleResultsPage from './public/european/EuropeanRifleResultsPage'
import SeriesResultsPage from './public/series-results/SeriesResultsPage'
import RelayResultsPage from './public/relay/RelayResultsPage'
import RaceMediaPage from './public/media/RaceMediaPage'
import NordicSubSportResultsPage from './public/nordic/NordicSubSportResultsPage'
import RacePage from './public/race-page/RacePage'
import CupMediaPage from './public/cup/CupMediaPage'
import CupSeriesPage from './public/cup/CupSeriesPage'
import CupPage from './public/cup/CupPage'
import AnnouncementPage from './public/announcements/AnnouncementPage'
import AnnouncementsPage from './public/announcements/AnnouncementsPage'
import HomePage from './public/home/HomePage'
import RacesPage from './public/races/RacesPage'
import InfoPage from './public/info/InfoPage'
import PricesPage from './public/info/PricesPage'
import QAndAPage from './public/info/QAndAPage'
import FeedbackPage from './public/feedback/FeedbackPage'
import SportsInfoPage from './public/info/SportsInfoPage'

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
