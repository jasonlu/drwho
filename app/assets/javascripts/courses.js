//$(document).ajaxStop($.unblockUI); 
$(document).ready(function(){
  $('a.add-to-cart').click(function(){
    //$.blockUI({ message: null });
    var thisId = $(this).data('id');
    $(this).attr('disabled', true).removeClass('add-to-cart').unbind('click');
    $.post('/cart/add.json', {id: thisId}, function(res){
      //$.unblockUI
      return true;
    }, 'json');
  });
});