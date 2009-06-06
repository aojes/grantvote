// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$.fn.pause = function(duration) {
    $(this).animate({ dummy: 1 }, duration);
    return this;
};


$(document).ready( function(){
  $('.rounded').corners("3px");
  $('div.pagination a').corners("4px");
  $('#errorExplanation').corners("6px");
  $('.success').corners("6px");
  $('.notice').corners("6px");
  $('.error').corners("6px");
  $('.pagination').corners("6px");
  $('#flash-notice').grow().highlight().pause(9000).shrink();
  $('#flash-warning').grow().highlight().pause(9000).shrink();
  $('#flash-error').grow().highlight().pause(9000).shrink();
});


