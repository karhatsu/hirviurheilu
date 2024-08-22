function insert_fields(link, method, content) {
  const new_id = new Date().getTime()
  const regexp = new RegExp('new_' + method, 'g')
  jQuery(link).before(content.replace(regexp, new_id))
}

function remove_fields(link, hide_class, removal_question) {
  if (removal_question == '' || confirm(removal_question)) {
    const hidden_field = jQuery(link).prev('input[type=hidden]').val('1')
    if (hidden_field) {
      hidden_field.value = '1'
    }
    jQuery(link).closest('.' + hide_class).hide()
  }
}

function calculateThreeSportsShotsResult(card) {
  let result = 0
  let error = false
  const total = card.find('.shots-total-input').val()
  if (total !== '') {
    result = parseInt(total, 10)
    if (result >= 0 && result <= 100) {
      card.find('.shot').each(function() {
        if ($(this).val() !== '') {
          error = true
        }
      })
    } else {
      error = true
    }
  } else {
    const errorAndSum = sumOfShots(card, 10, 0, 10)
    error = errorAndSum[0]
    result = errorAndSum[1]
  }
  if (error) {
    result = '?'
  }
  card.find('.card__main-value').text(result)
}

function calculateShootingRaceShotsResult(card, bestShotValue, roundMaxScore, qualificationRoundShotCount, totalShotCount) {
  let error = false
  const qualificationTotal = card.find('.shots-total-input:eq(0)').val()
  const finalTotal = card.find('.shots-total-input:eq(1)').val()
  let q
  let f
  if (qualificationTotal !== '' || finalTotal !== '') {
    q = parseInt(qualificationTotal)
    f = parseInt(finalTotal) || 0
  } else {
    const errorAndSumQ = sumOfShots(card, bestShotValue, 0, qualificationRoundShotCount)
    const errorAndSumF = sumOfShots(card, bestShotValue, qualificationRoundShotCount, totalShotCount)
    error = errorAndSumQ[0] || errorAndSumF[0]
    q = errorAndSumQ[1]
    f = errorAndSumF[1]
  }
  card.find('.card__main-value').text(formatResult(error, q, f, roundMaxScore))
}

function calculateShootingRaceShotsResultForQ(card, bestShotValue, roundMaxScore, qualificationRoundShotCount) {
  let error = false
  const qualificationTotal = card.find('.shots-total-input:eq(0)').val()
  const finalTotal = card.find('.shots-total-input:eq(1)').val()
  const f = parseInt(finalTotal) || 0
  let q
  if (qualificationTotal !== '') {
    q = parseInt(qualificationTotal)
  } else {
    const errorAndSumQ = sumOfShots(card, bestShotValue, 0, qualificationRoundShotCount)
    error = errorAndSumQ[0]
    q = errorAndSumQ[1]
  }
  card.find('.card__main-value').text(formatResult(error, q, f, roundMaxScore))
}

function calculateShootingRaceShotsResultForF(card, bestShotValue, roundMaxScore, qualificationRoundShotCount, totalShotCount) {
  let error = false
  const qualificationTotal = card.find('.shots-total-input:eq(0)').val()
  const finalTotal = card.find('.shots-total-input:eq(1)').val()
  const q = parseInt(qualificationTotal)
  let f
  if (finalTotal !== '') {
    f = parseInt(finalTotal) || 0
  } else {
    const errorAndSumF = sumOfShots(card, bestShotValue, qualificationRoundShotCount, totalShotCount)
    error = errorAndSumF[0]
    f = errorAndSumF[1]
  }
  card.find('.card__main-value').text(formatResult(error, q, f, roundMaxScore))
}

function calculateInternationalRaceShotsResult(card, bestShotValue, shotCount) {
  let result = 0
  let error = false
  const total = card.find('.shots-total-input').val()
  const maxScore = shotCount * bestShotValue
  if (total !== '') {
    result = parseInt(total, 10)
    if (result >= 0 && result <= maxScore) {
      card.find('.shot').slice(0, shotCount).each(function() {
        if ($(this).val() !== '') {
          error = true
        }
      })
    } else {
      error = true
    }
  } else {
    const errorAndSum = sumOfShots(card, bestShotValue, 0, shotCount)
    error = errorAndSum[0]
    result = errorAndSum[1]
  }
  if (error) {
    result = '?'
  }
  card.find('.card__main-value').text(result)
}

function calculateEuropeanShotsResult(card, fieldCount, bestShotValue, shotCount) {
  let result = 0
  let error = false
  const maxScore = shotCount * 10
  for (let i = 0; i < fieldCount; i++) {
    const total = card.find('.shots-total-input')[i].value
    if (total !== '') {
      const subResult = parseInt(total)
      if (subResult >= 0 && subResult <= maxScore) {
        result += subResult
        card.find('.shot').slice(i * shotCount, (i + 1) * shotCount).each(function() {
          if ($(this).val() !== '') {
            error = true
          }
        })
      } else {
        error = true
      }
    } else {
      const errorAndSum = sumOfShots(card, bestShotValue, i * shotCount, (i + 1) * shotCount)
      error = error || errorAndSum[0]
      result += errorAndSum[1]
    }
  }
  if (error) {
    result = '?'
  }
  card.find('.card__main-value').text(result)
}

function formatResult(error, q, f, roundMaxScore) {
  if (!error && q >= 0 && q <= roundMaxScore && f >= 0 && f <= roundMaxScore) {
    return q + ' + ' + f + ' = ' + (q + f)
  }
  return '?'
}

function sumOfShots(card, bestShotValue, firstIndex, lastIndex) {
  let error = false
  let sum = 0
  card.find('.shot').slice(firstIndex, lastIndex).each(function() {
    if ($(this).val() !== '') {
      const shot = parseInt($(this).val())
      if (shot >= 0 && shot <= bestShotValue) {
        sum += shot === 11 ? 10 : shot
      } else {
        error = true
      }
    }
  })
  return [error, sum]
}

function updateInlineMessage(locator, type, text) {
  $(locator).removeClass().addClass('message message--inline message--' + type).text(text)
}

function resetInlineMessage(locator) {
  $(locator).removeClass().text('')
}

function findAndResetInlineMessage(inputFieldLocator) {
  resetInlineMessage($(inputFieldLocator).closest('.card').find('.message'))
}

$(document).ready(function() {
  $(document).on('click', '.binary-shot__option', function() {
    const alreadySelected = $(this).hasClass('binary-shot__option--selected')
    if (alreadySelected) {
      $(this).removeClass('binary-shot__option--selected')
      $(this).parent().find('input').val('').trigger('change')
    } else {
      const value = $(this).hasClass('binary-shot__option--1') ? 1 : 0
      const otherValue = value === 1 ? 0 : 1
      $(this).addClass('binary-shot__option--selected')
      $(this).parent().find('.binary-shot__option--' + otherValue).removeClass('binary-shot__option--selected')
      $(this).parent().find('input').val(value).trigger('change')
    }
  })
  $(document).on('click', '.button--select-all-shots', function() {
    $(this).parent().find('.binary-shot__option--0').removeClass('binary-shot__option--selected')
    $(this).parent().find('.binary-shot__option--1').addClass('binary-shot__option--selected')
    $(this).parent().find('input').val(1)
    $(this).parent().find('input').trigger('change')
  })
  $(document).on('click', '.button--select-all-tens', function() {
    $(this).closest('.card__middle-row').find('.shot').val(10)
    $(this).closest('.card__middle-row').find('.shots-total-input').val('')
    $(this).closest('.card__middle-row').find('input').trigger('change')
  })
})
