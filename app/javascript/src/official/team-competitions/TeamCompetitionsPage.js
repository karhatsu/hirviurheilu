import useOfficialMenu from '../menu/useOfficialMenu'
import { useCallback, useEffect, useState } from 'react'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'
import { buildOfficialRacePath } from '../../util/routeUtil'
import { useRace } from '../../util/useRace'
import IncompletePage from '../../common/IncompletePage'
import { useParams } from 'react-router'
import { del, get, post, put } from '../../util/apiClient'
import TeamCompetitionForm from './TeamCompetitionForm'
import Message from '../../common/Message'
import useTitle from '../../util/useTitle'

const emptyTeamCompetition = {
  name: '',
  teamCompetitorCount: 3,
  multipleTeams: false,
  showPartialTeams: false,
  useTeamName: false,
  nationalRecord: '',
  seriesIds: [],
  ageGroupIds: [],
}

const sorter = (a, b) => a.name.localeCompare(b.name)

const formatNames = (race, series, ageGroups) => {
  const seriesNames = series.map((s) => s.name)
  const ageGroupNames = ageGroups.map((ag) => ag.name)
  return seriesNames.concat(ageGroupNames).join(', ')
}

const TeamCompetitionCard = ({ t, tc, race, onEdit, onDelete }) => (
  <div className="card">
    <div className="card__middle">
      <div className="card__name">{tc.name}</div>
      <div className="card__middle-row">
        {tc.teamCompetitorCount} {t('competitorsPerTeam')}
      </div>
      <div className="card__middle-row">{formatNames(race, tc.series, tc.ageGroups)}</div>
    </div>
    <div className="card__buttons">
      <Button type="edit" onClick={onEdit}>
        Muokkaa
      </Button>
      <Button type="danger" onClick={onDelete}>
        Poista
      </Button>
    </div>
  </div>
)

const TeamCompetitionsPage = () => {
  const { t } = useTranslation()
  const { raceId } = useParams()
  const { fetching, error, race } = useRace()
  const { setSelectedPage } = useOfficialMenu()
  const [teamCompetitions, setTeamCompetitions] = useState(undefined)
  const [teamCompetitionsError, setTeamCompetitionsError] = useState()
  const [adding, setAdding] = useState(false)
  const [editing, setEditing] = useState()
  const [formErrors, setFormErrors] = useState()
  const [deleteError, setDeleteError] = useState()

  useEffect(() => setSelectedPage('teamCompetitions'), [setSelectedPage])
  useTitle(race && `${t('teamCompetitions')} - ${race.name}`)

  useEffect(() => {
    get(`/official/races/${raceId}/team_competitions.json`, (err, response) => {
      if (err) setTeamCompetitionsError(err)
      else setTeamCompetitions(response.teamCompetitions)
    })
  }, [raceId])

  const onCreate = useCallback(
    (data) => {
      post(`/official/races/${raceId}/team_competitions.json`, { team_competition: data }, (errors, response) => {
        if (errors) {
          setFormErrors(errors)
        } else {
          setTeamCompetitions((tcs) => [...tcs, response].sort(sorter))
          setAdding(false)
        }
      })
    },
    [raceId],
  )

  const onUpdate = useCallback(
    (data) => {
      const { extraShots } = data
      const body = {
        team_competition: {
          ...data,
          id: undefined,
          series: undefined,
          ageGroups: undefined,
          extraShots: undefined,
        },
        extraShots,
      }
      put(`/official/races/${raceId}/team_competitions/${data.id}.json`, body, (errors, response) => {
        if (errors) {
          setFormErrors(errors)
        } else {
          setTeamCompetitions((teamCompetitions) => {
            const index = teamCompetitions.findIndex((tc) => tc.id === data.id)
            const newTeamCompetitions = [...teamCompetitions]
            newTeamCompetitions[index] = { ...response }
            return newTeamCompetitions.sort(sorter)
          })
          setEditing(undefined)
        }
      })
    },
    [raceId],
  )

  const onDelete = useCallback(
    (id) => {
      if (!confirm(t('teamCompetitionDeleteConfirmation'))) return
      del(`/official/races/${raceId}/team_competitions/${id}`, (errors) => {
        if (errors) {
          setDeleteError(errors[0])
        } else {
          setTeamCompetitions((teamCompetitions) => {
            const index = teamCompetitions.findIndex((c) => c.id === id)
            const newTeamCompetitions = [...teamCompetitions]
            newTeamCompetitions.splice(index, 1)
            return newTeamCompetitions
          })
        }
      })
    },
    [t, raceId],
  )

  if (!race || !teamCompetitions) {
    return (
      <IncompletePage
        fetching={fetching || !teamCompetitions}
        error={error || teamCompetitionsError}
        title={t('teamCompetitions')}
      />
    )
  }

  if (adding) {
    return (
      <TeamCompetitionForm
        errors={formErrors}
        initialData={{ ...emptyTeamCompetition }}
        onCancel={() => setAdding(false)}
        onSave={onCreate}
        race={race}
        title={t('addTeamCompetition')}
      />
    )
  }

  if (editing) {
    return (
      <TeamCompetitionForm
        errors={formErrors}
        initialData={editing}
        onCancel={() => setEditing(false)}
        onSave={onUpdate}
        race={race}
        title={t('editTeamCompetition')}
      />
    )
  }

  return (
    <div>
      <h2>{t('teamCompetitions')}</h2>
      {deleteError && <Message type="error">{deleteError}</Message>}
      <div className="row">
        {teamCompetitions.map((tc) => (
          <div key={tc.id} className="col-xs-12 col-sm-6 col-md-4">
            <TeamCompetitionCard
              t={t}
              tc={tc}
              race={race}
              onEdit={() => setEditing(tc)}
              onDelete={() => onDelete(tc.id)}
            />
          </div>
        ))}
      </div>
      <div className="buttons">
        <Button type="add" onClick={() => setAdding(true)} id="add_button">
          {t('addTeamCompetition')}
        </Button>
      </div>
      <div className="buttons buttons--nav">
        <Button href={buildOfficialRacePath(race.id)} type="back">
          {t('backToOfficialRacePage')}
        </Button>
      </div>
    </div>
  )
}

export default TeamCompetitionsPage
