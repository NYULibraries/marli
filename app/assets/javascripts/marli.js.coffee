$ ->
  $("#user_dob").datepicker {
    changeMonth: true,
    changeYear: true,
    yearRange: '1900:c',
    dateFormat: 'yy-mm-dd'
  }
  $("#user_dob").attr "readonly", "readonly"
  $("*[type='submit'][data-remote='true']").hide()
  $("#show_user").on 'change', "input[type='checkbox']", ->
    $(this).closest("form").submit()
  $(".dob-popover").show()
  $(".js_hide").hide()
