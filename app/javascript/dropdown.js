$(document).ready(function(){
  // $('#month-toggler').click(function() {
  //   $('#month-lists').slideToggle();
  //   return false;
  // });
  $('.toggler').click(function() {
    $(this).next().slideToggle('fast');
    return false;
  });
});