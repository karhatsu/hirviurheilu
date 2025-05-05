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

function updateInlineMessage(locator, type, text) {
  $(locator).removeClass().addClass('message message--inline message--' + type).text(text)
}

function resetInlineMessage(locator) {
  $(locator).removeClass().text('')
}
