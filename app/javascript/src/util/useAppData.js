const parseRaceRight = (raceRight) => {
  if (!raceRight) return undefined
  const rr = JSON.parse(raceRight)
  return {
    clubId: rr.club_id,
    newClubs: rr.new_clubs,
    onlyAddCompetitors: rr.only_add_competitors,
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
  }
}

export default useAppData
