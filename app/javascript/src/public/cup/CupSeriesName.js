export default function CupSeriesName({ cupSeries }) {
  const { name, seriesNames } = cupSeries
  if (!seriesNames || seriesNames === name) return name
  return `${name} (${seriesNames.split(',').join(', ')})`
}
