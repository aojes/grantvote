$(document).ready( function(){

  $.fn.qtip.styles.grantvotestyle = { 
     width: 200,
     background: '#eeeeee',
     color: 'black',
     textAlign: 'center',
     border: {
        width: 3,
        radius: 5,
        color: '#cccccc'
     },
    
     name: 'light' 
  }


    $('img[title]').qtip({ style: { name: 'grantvotestyle', tip: true
   }, position: {
        corner: {
           target: 'leftMiddle',
           tooltip: 'bottomLeft'
        },
    // adjust: { scroll: true,  x: 30, y: 0 }
     target: 'mouse',
     adjust: { mouse: true }

     },
    show: { effect: { type: 'slide', length: '100' } }
   })

});
