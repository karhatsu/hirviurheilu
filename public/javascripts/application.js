// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
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

function calculate_shots_result(row) {
  result = 0;
  error = false;
  total = row.find('.total').val();
  if(total != '') {
    result = parseInt(total, 10);
    if(result >= 0 && result <= 100) {
      row.find('.shot').each(function() {
        if($(this).val() != '') {
          error = true;
        }
      });
    } else {
      error = true;
    }
  } else {
    row.find('.shot').each(function() {
      if($(this).val() != '') {
        shot = parseInt($(this).val(), 10);
        if(shot >= 0 && shot <= 10) {
          result += shot;
        } else {
          error = true;
        }
      }
    });
  }
  if(error) {
    result = '?';
  }
  row.find('.result').val(result);
}