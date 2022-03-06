const useAppData = () => {
  const appElement = document.getElementById('react-app')
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
  }
}

export default useAppData
