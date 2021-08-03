const useAppData = () => {
  const appElement = document.getElementById('react-app')
  if (!appElement) return {}
  const admin = appElement.getAttribute('data-admin') !== null
  const environment = appElement.getAttribute('data-env')
  const locale = appElement.getAttribute('data-locale')
  const titlePrefix = appElement.getAttribute('data-title-prefix')
  const userId = appElement.getAttribute('data-user')
  return { admin, environment, locale, titlePrefix, userId }
}

export default useAppData
