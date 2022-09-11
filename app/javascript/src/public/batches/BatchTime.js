import useTranslation from '../../util/useTranslation'

const subTime = (t, sport, subSport, daysCount, date, time) => {
  if (!time) return
  return `${t(`${sport}_${subSport}`)}: ${daysCount > 1 ? date : ''} ${time}`
}

export default function BatchTime({ race, batch }) {
  const { t } = useTranslation()
  const { daysCount, sport } = race
  const { nordic, european } = sport
  const { date, date2, date3, date4, time, time2, time3, time4 } = batch
  if (nordic) {
    return [
      subTime(t, 'nordic', 'trap', daysCount, date, time),
      subTime(t, 'nordic', 'shotgun', daysCount, date2, time2),
      subTime(t, 'nordic', 'rifle_moving', daysCount, date3, time3),
      subTime(t, 'nordic', 'rifle_standing', daysCount, date4, time4),
    ].filter(t => t).join(' - ')
  } else if (european) {
    return [
      subTime(t, 'european', 'trap', daysCount, date, time),
      subTime(t, 'european', 'compak', daysCount, date2, time2),
      subTime(t, 'european', 'rifle', daysCount, date3, time3),
    ].filter(t => t).join(' - ')
  } else if (daysCount > 1) {
    return `${date} ${time}`
  }
  return time
}
