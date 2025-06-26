export const showCaliberField = (sport) => ['METSASTYSHIRVI', 'METSASTYSLUODIKKO'].includes(sport.key)

export const caliberItems = ['.17 HMR', '.22', '.222', '.223', '.243', '.308', '5,7', '6,5'].map((cal) => ({
  id: cal,
  name: cal,
}))
