$(document).ready(function(){
  $('.toggler').click(function() {
    $(this).next().slideToggle('fast');
    return false;
  });

  $('.edit-comment').click(function() {
    $(this).toggleClass('dim');
    $(this).parent().prev(".edit-comment-form").slideToggle('fast');
    return false;
  })

  $('.active-reply-btn').click(function() {
    $(this).toggleClass('dim');
    $(this).parent().prev(".reply-comment-form").slideToggle('fast');
    $(this).parent().prev().prev(".reply-comment-form").slideToggle('fast');
    return false;
  })

  $('.reply-drop').click(function() {
    $(this).toggleClass('dim');
    $(this).parent().nextAll(".reply-content").slideToggle('fast');
    return false;
  })

  $('#top-btn').click(function() {
    $('html, body').animate({scrollTop:0});
  })

  $('.show-image, .attachment, .large-image, .mordal-remove').click(function() {
    $('#image-mordal').fadeToggle();
  })
  
});