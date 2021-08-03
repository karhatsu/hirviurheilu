import { useEffect } from 'react'
import useAppData from './useAppData'

const useTitle = title => {
  const { titlePrefix } = useAppData()
  useEffect(() => {
    if (title) {
      document.title = `${titlePrefix}${title}`
    }
  }, [title, titlePrefix])
}

export default useTitle
