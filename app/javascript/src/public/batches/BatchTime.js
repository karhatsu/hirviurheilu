import useTranslation from '../../util/useTranslation'

const subTime = (t, sport, subSport, time) => {
  if (!time) return
  return `${t(`${sport}_${subSport}`)}: ${time}`
}

export default function BatchTime({ race, batch }) {
  const { t } = useTranslation()
  const { nordic, european } = race.sport
  const { time, time2, time3, time4 } = batch
  if (nordic) {
    return [
      subTime(t, 'nordic', 'trap', time),
      subTime(t, 'nordic', 'shotgun', time2),
      subTime(t, 'nordic', 'rifle_moving', time3),
      subTime(t, 'nordic', 'rifle_standing', time4),
    ].filter(t => t).join(' - ')
  } else if (european) {
    return [
      subTime(t, 'european', 'trap', time),
      subTime(t, 'european', 'compak', time2),
      subTime(t, 'european', 'rifle', time3),
    ].filter(t => t).join(' - ')
  }
  return time
}
