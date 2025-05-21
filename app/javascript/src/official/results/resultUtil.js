import getYear from 'date-fns/getYear'

export const shotValue = (rawValue) => {
  if (rawValue === 11) return 10
  return rawValue || 0
}

const shotSum = (shots) => shots.reduce((sum, shot) => sum + shotValue(shot), 0)

export const shotCount = (shots) => shots.filter((shot) => shot !== '').length

export const calculateShootingScore = (scoreInput, shots, maxScore) => {
  const hasShot = !!shots.find((s) => s)
  if (scoreInput) {
    if (scoreInput < 0 || scoreInput > maxScore || hasShot) return '?'
    return scoreInput
  } else if (hasShot) {
    return shotSum(shots)
  }
  return ''
}

export const capitalize = (s) => {
  return s
    .split('_')
    .map((str, i) => {
      if (i === 0) return str
      return str[0].toUpperCase() + str.slice(1)
    })
    .join('')
}

export const nordicConfig = (subSport, race) => {
  switch (subSport) {
    case 'trap':
      return {
        fieldNames: {
          scoreInput: 'nordicTrapScoreInput',
          shots: 'nordicTrapShots',
          extraShots: 'nordicTrapExtraShots',
        },
        shotCount: 25,
        shotsPerExtraRound: 1,
        bestShotValue: getYear(new Date(race.startDate)) >= 2025 ? 4 : 1,
        bestExtraShotValue: 1,
      }
    case 'shotgun':
      return {
        fieldNames: {
          scoreInput: 'nordicShotgunScoreInput',
          shots: 'nordicShotgunShots',
          extraShots: 'nordicShotgunExtraShots',
        },
        shotCount: 25,
        shotsPerExtraRound: 1,
        bestShotValue: 1,
        bestExtraShotValue: 1,
      }
    case 'rifleMoving':
      return {
        fieldNames: {
          scoreInput: 'nordicRifleMovingScoreInput',
          shots: 'nordicRifleMovingShots',
          extraShots: 'nordicRifleMovingExtraShots',
        },
        shotCount: 10,
        shotsPerExtraRound: 2,
        bestShotValue: 10,
        bestExtraShotValue: 10,
      }
    case 'rifleStanding':
      return {
        fieldNames: {
          scoreInput: 'nordicRifleStandingScoreInput',
          shots: 'nordicRifleStandingShots',
          extraShots: 'nordicRifleStandingExtraShots',
        },
        shotCount: 10,
        shotsPerExtraRound: 2,
        bestShotValue: 10,
        bestExtraShotValue: 10,
      }
    default:
      throw new Error(`Unknown nordic sub sport: ${subSport}`)
  }
}

export const competitorsOnlyToAgeGroups = (series) => series.name.match(/^S\d\d?$/)
