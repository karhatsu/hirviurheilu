import Button from '../../common/Button'
import { buildLimitedOfficialEditCompetitorPath } from '../../util/routeUtil'

const CompetitorsList = ({ competitors, raceId, deleteCompetitor }) => {
  return (
    <div>
      <h2>Lisätyt kilpailijat ({competitors.length})</h2>
      <div id="all_competitors" className="row">
        {competitors.map((competitor) => (
          <div key={competitor.id} className="col-xs-12 col-sm-6 col-md-4">
            <div className="card">
              <div className="card__middle">
                <div className="card__name">
                  {competitor.lastName} {competitor.firstName}
                </div>
                <div className="card__middle-row">
                  {competitor.club.name}
                  {competitor.teamName && ` (${competitor.teamName})`}
                </div>
                <div className="card__middle-row">
                  {competitor.series.name}
                  {competitor.ageGroup && ` (${competitor.ageGroup.name})`}
                </div>
              </div>
              <div className="card__buttons">
                <Button href={buildLimitedOfficialEditCompetitorPath(raceId, competitor.id)} type="edit">
                  Muokkaa
                </Button>
                <Button onClick={deleteCompetitor(competitor.id)} type="danger">
                  Poista
                </Button>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}

export default CompetitorsList
