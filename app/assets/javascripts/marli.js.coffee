$ ->
  $( "#dob" ).datepicker {
    changeMonth: true,
    changeYear: true,
    yearRange: '1900:c'
  }
  $("*[type='submit'][data-remote='true']").hide()
  $("#show_user").find("input[type='checkbox']").live 'change', ->
    $(this).closest("form").submit()
  
