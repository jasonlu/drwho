$(document).ready(function(){

if (!Modernizr.inputtypes.date) {
  $('input[type=date]').datepicker({
    dateFormat: 'yy-mm-dd',
    minDate: new Date()
  });
}


});

$(document).ajaxStart(function() {
  $.blockUI({ message: '<img src="/images/loading.gif" >' });
});

$(document).ajaxStop($.unblockUI);