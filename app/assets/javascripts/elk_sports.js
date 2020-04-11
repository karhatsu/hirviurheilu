function insert_fields(link, method, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + method, "g")
  jQuery(link).before(content.replace(regexp, new_id));
}

function remove_fields(link, hide_class, removal_question) {
  if (removal_question == "" || confirm(removal_question)) {
    var hidden_field = jQuery(link).prev("input[type=hidden]").val("1");
    if (hidden_field) {
      hidden_field.value = '1';
    }
    jQuery(link).closest("." + hide_class).hide();
  }
}

function calculateThreeSportsShotsResult(card) {
  let result = 0;
  let error = false;
  const total = card.find('.shots-total-input').val();
  if(total !== '') {
    result = parseInt(total, 10);
    if(result >= 0 && result <= 100) {
      card.find('.shot').each(function() {
        if($(this).val() !== '') {
          error = true;
        }
      });
    } else {
      error = true;
    }
  } else {
    const errorAndSum = sumOfShots(card, false, 0, 10)
    error = errorAndSum[0]
    result = errorAndSum[1]
  }
  if(error) {
    result = '?';
  }
  card.find('.card__main-value').text(result);
}

function calculateShootingRaceShotsResult(card, elevenAsTen) {
  let error = false
  const qualificationTotal = card.find('.shots-total-input:eq(0)').val()
  const finalTotal = card.find('.shots-total-input:eq(1)').val()
  let q
  let f
  if (qualificationTotal !== '' || finalTotal !== '') {
    q = parseInt(qualificationTotal)
    f = parseInt(finalTotal) || 0
  } else {
    const errorAndSumQ = sumOfShots(card, elevenAsTen, 0, 10)
    const errorAndSumF = sumOfShots(card, elevenAsTen, 10, 20)
    error = errorAndSumQ[0] || errorAndSumF[0]
    q = errorAndSumQ[1]
    f = errorAndSumF[1]
  }
  card.find('.card__main-value').text(formatResult(error, q, f));
}

function calculateShootingRaceShotsResultForQ(card, elevenAsTen) {
  let error = false
  const qualificationTotal = card.find('.shots-total-input:eq(0)').val()
  const finalTotal = card.find('.shots-total-input:eq(1)').val()
  const f = parseInt(finalTotal) || 0
  let q
  if (qualificationTotal !== '') {
    q = parseInt(qualificationTotal)
  } else {
    const errorAndSumQ = sumOfShots(card, elevenAsTen, 0, 10)
    error = errorAndSumQ[0]
    q = errorAndSumQ[1]
  }
  card.find('.card__main-value').text(formatResult(error, q, f));
}

function calculateShootingRaceShotsResultForF(card, elevenAsTen) {
  let error = false
  const qualificationTotal = card.find('.shots-total-input:eq(0)').val()
  const finalTotal = card.find('.shots-total-input:eq(1)').val()
  const q = parseInt(qualificationTotal)
  let f
  if (finalTotal !== '') {
    f = parseInt(finalTotal) || 0
  } else {
    const errorAndSumF = sumOfShots(card, elevenAsTen, 10, 20)
    error = errorAndSumF[0]
    f = errorAndSumF[1]
  }
  card.find('.card__main-value').text(formatResult(error, q, f));
}

function formatResult(error, q, f) {
  if (!error && q >= 0 && q <= 100 && f >= 0 && f <= 100) {
    return q + ' + ' + f + ' = ' + (q + f)
  }
  return '?'
}

function sumOfShots(card, elevenAsTen, firstIndex, lastIndex) {
  const maxValue = elevenAsTen ? 11 : 10
  let error = false
  let sum = 0
  card.find('.shot').slice(firstIndex, lastIndex).each(function() {
    if($(this).val() !== '') {
      const shot = parseInt($(this).val())
      if(shot >= 0 && shot <= maxValue) {
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
