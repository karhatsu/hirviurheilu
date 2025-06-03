import useAppData from './useAppData'
import { useRace } from './useRace'

const useMinimalRace = () => {
  const { race: ssRace } = useAppData()
  const { race: apiRace } = useRace()
  return apiRace || ssRace
}

export default useMinimalRace
