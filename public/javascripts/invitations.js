jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})


$(document).ready( function(){
 
  
  $('#new_invitation').hide();
  $('#new_invitation').validate();
  $('.send_invite_link').click(function() {
  $('#new_invitation').animate({height: 'show', width: 'show', opacity: 'show'}, 'slow');
  $(this).hide();

  });
 $("#new_invitation").submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

});

