const shotSum = shots => shots.reduce((sum, shot) => sum + (shot || 0), 0)

export const shotCount = shots => shots.filter(shot => shot !== '').length

export const calculateShootingScore = (scoreInput, shots) => {
  const hasShot = !!shots.find(s => s)
  if (scoreInput) {
    if (scoreInput < 0 || scoreInput > 100  || hasShot) return '?'
    return scoreInput
  } else if (hasShot) {
    return shotSum(shots)
  }
  return ''
}
