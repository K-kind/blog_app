$(document).ready(function(){
  $('.toggler').click(function() {
    $(this).next().slideToggle('fast');
    return false;
  });

  $('.edit-comment').click(function() {
    $(this).toggleClass('dim');
    $(this).parent().parent().prev("section").slideToggle('fast');
    return false;
  })

  $('#top-btn').click(function() {
    $('html, body').animate({scrollTop:0});
  })
  
});