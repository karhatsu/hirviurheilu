export const timeFromSeconds = seconds => {
  const h = Math.floor(seconds / 3600)
  const min = Math.floor((seconds - h * 3600) / 60)
  const sec = seconds % 60
  const pad = n => n < 10 ? `0${n}` : n
  if (h >= 1) return `${h}:${pad(min)}:${pad(sec)}`
  return `${pad(min)}:${pad(sec)}`
}
