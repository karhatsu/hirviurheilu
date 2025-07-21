const parseRaceRight = (raceRight) => {
  if (!raceRight) return undefined
  const rr = JSON.parse(raceRight)
  return {
    clubId: rr.club_id,
    newClubs: rr.new_clubs,
    onlyAddCompetitors: rr.only_add_competitors,
  }
}

const parseRace = (race) => {
  if (!race) return
  const { club_level, end_date, id, name, location, series, sport, sport_key, start_date } = JSON.parse(race)
  return {
    clubLevel: club_level,
    endDate: end_date,
    id,
    name,
    location,
    series,
    sport,
    sportKey: sport_key,
    startDate: start_date,
  }
}

const useAppData = () => {
  const appElement = document.getElementsByClassName('react-app')[0]
  if (!appElement) return {}
  const admin = appElement.getAttribute('data-admin') !== null
  const environment = appElement.getAttribute('data-env')
  const locale = appElement.getAttribute('data-locale')
  const noNav = appElement.getAttribute('data-no-nav') === 'true'
  const titlePrefix = appElement.getAttribute('data-title-prefix')
  const userId = appElement.getAttribute('data-user-id')
  const userEmail = appElement.getAttribute('data-user-email')
  const userFirstName = appElement.getAttribute('data-user-first-name')
  const userLastName = appElement.getAttribute('data-user-last-name')
  const userRaceRight = appElement.getAttribute('data-user-race-right') // only limited official
  const race = appElement.getAttribute('data-race')
  const cupName = appElement.getAttribute('data-cup-name')
  return {
    admin,
    environment,
    locale,
    noNav,
    titlePrefix,
    userId: userId && parseInt(userId),
    userEmail,
    userFirstName,
    userLastName,
    userRaceRight: parseRaceRight(userRaceRight),
    race: parseRace(race),
    cup: cupName && { name: cupName },
  }
}

export const getLocale = () => {
  const appElement = document.getElementsByClassName('react-app')[0]
  return appElement.getAttribute('data-locale')
}

export default useAppData
