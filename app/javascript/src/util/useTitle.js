import { useEffect } from 'react'

const useTitle = title => {
  useEffect(() => {
    if (title) {
      const appElement = document.getElementById('react-app')
      if (!appElement) return null
      const titlePrefix = appElement.getAttribute('title_prefix')
      document.title = `${titlePrefix}${title}`
    }
  }, [title])
}

export default useTitle
