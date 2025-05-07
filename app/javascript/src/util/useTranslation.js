import { useCallback } from 'react'

const useTranslation = () => {
  const t = useCallback((key, params) => {
    let text = window.translations[key] || window.officialTranslations[key]
    if (!params) return text
    Object.keys(params).forEach((paramKey) => {
      text = text.replace(`{{${paramKey}}}`, params[paramKey])
    })
    return text
  }, [])
  return { t }
}

export default useTranslation
