$( "#toggle_sidebar" ).click(function() {
  $( "#sidebar" ).toggle();
  $( "#content" ).toggleClass( "col-lg-9", "col-sm-12" );
});

