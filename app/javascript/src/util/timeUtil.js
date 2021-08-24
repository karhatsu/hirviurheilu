import format from 'date-fns/format'
import isToday from 'date-fns/isToday'

export const timeFromSeconds = (seconds, signed) => {
  const absSeconds = Math.abs(seconds)
  let sign = ''
  if (seconds < 0) {
    sign = '-'
  } else if (signed) {
    sign = '+'
  }
  const h = Math.floor(absSeconds / 3600)
  const min = Math.floor((absSeconds - h * 3600) / 60)
  const sec = absSeconds % 60
  const pad = n => n < 10 ? `0${n}` : n
  if (h >= 1) return `${sign}${h}:${pad(min)}:${pad(sec)}`
  return `${sign}${pad(min)}:${pad(sec)}`
}

export const formatTodaysTime = time => {
  const dateFormat = isToday(time) ? 'HH:mm' : 'dd.MM.yyyy HH:mm'
  return format(time, dateFormat)
}

export const formatDateInterval = (startDate, endDate) => {
  const start = format(new Date(startDate), 'dd.MM.yyyy')
  const end = endDate && startDate !== endDate && format(new Date(endDate), 'dd.MM.yyyy')
  return end ? `${start} - ${end}` : start
}
