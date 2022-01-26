import { useEffect } from 'react'
import useAppData from './useAppData'

const buildTitle = stringOrArray => {
  if (Array.isArray(stringOrArray)) {
    return stringOrArray.concat('Hirviurheilu').join(' - ')
  } else if (stringOrArray.indexOf('Hirviurheilu') === 0) {
    return stringOrArray
  }
  return `${stringOrArray} - Hirviurheilu`
}

const useTitle = stringOrArray => {
  const { titlePrefix } = useAppData()
  useEffect(() => {
    if (stringOrArray) {
      document.title = `${titlePrefix}${buildTitle(stringOrArray)}`
    }
  }, [stringOrArray, titlePrefix])
}

export default useTitle
