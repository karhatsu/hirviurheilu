import { useEffect, useState } from 'react'
import { get } from './apiClient'

const useDistricts = () => {
  const [districts, setDistricts] = useState([])
  useEffect(() => {
    // eslint-disable-next-line node/handle-callback-err
    get('/api/v2/public/districts', (err, data) => {
      if (data.districts) setDistricts(data.districts)
    })
  }, [])
  return { districts }
}

export default useDistricts
