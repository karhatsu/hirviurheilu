import { useEffect, useState } from 'react'
import { get } from './apiClient'

const useDistricts = () => {
  const [districts, setDistricts] = useState([])
  useEffect(() => {
    get('/api/v2/public/districts', (err, data) => {
      if (data.districts) setDistricts(data.districts)
    })
  }, [])
  return { districts }
}

export default useDistricts
