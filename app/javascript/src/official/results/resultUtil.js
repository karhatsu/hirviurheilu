export const shotValue = rawValue => {
  if (rawValue === 11) return 10
  return rawValue || 0
}

const shotSum = shots => shots.reduce((sum, shot) => sum + shotValue(shot), 0)

export const shotCount = shots => shots.filter(shot => shot !== '').length

export const calculateShootingScore = (scoreInput, shots, maxScore) => {
  const hasShot = !!shots.find(s => s)
  if (scoreInput) {
    if (scoreInput < 0 || scoreInput > maxScore  || hasShot) return '?'
    return scoreInput
  } else if (hasShot) {
    return shotSum(shots)
  }
  return ''
}

export const capitalize = s => {
  return s.split('_').map((str, i) => {
    if (i === 0) return str
    return str[0].toUpperCase() + str.slice(1)
  }).join('')
}
