// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$.fn.pause = function(duration) {
    $(this).animate({ dummy: 1 }, duration);
    return this;
};

$.fn.qtip.styles.grantvotestyle = { 
    width: 200,
    background: '#eeeeee',
    color: 'black',
    textAlign: 'center',
    border: {
      width: 3,
      radius: 5,
      color: '#cccccc' },
  
    name: 'light' 
}

$(document).ready( function(){
  $('.rounded').corners("3px");
  $('div.pagination a, #group_members').corners("4px");
  $('#errorExplanation').corners("6px");
  $('.success').corners("6px");
  $('.notice').corners("6px");
  $('.error').corners("6px");
  $('.pagination').corners("6px");
  $('#flash-notice').grow().highlight().pause(9000).shrink();
  $('#flash-warning').grow().highlight().pause(9000).shrink();
  $('#flash-error').grow().highlight().pause(9000).shrink();
  $('#new_group').validate();


  $('img[title]').qtip({ style: { name: 'grantvotestyle', tip: true }, 
    position: {
        corner: {
           target: 'leftMiddle',
           tooltip: 'bottomLeft' },
      // adjust: { scroll: true,  x: 30, y: 0 }
      target: 'mouse',
      adjust: { mouse: true } },
    show: { effect: { type: 'slide', length: '100' } }
   });
  
});
