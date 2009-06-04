// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready( function(){
  $('.rounded').corners("3px");
  $('div.pagination a').corners("4px");
  $('.pagination').corners("6px");
});

$.fn.pause = function(duration) {
    $(this).animate({ dummy: 1 }, duration);
    return this;
};

$(document).ready( function(){
  $('#flash-notice').grow().highlight().pause(9000).shrink();
  $('#flash-warning').grow().highlight().pause(9000).shrink();
  $('#flash-error').grow().highlight().pause(9000).shrink();
});


