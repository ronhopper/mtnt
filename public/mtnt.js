$(document).ready(function() {
  $("a[class|='word']").hover(function() {
    var wordID = $(this).attr('class').split(' ')[0];
    $('.' + wordID).addClass('highlighted');
  }, function() {
    var wordID = $(this).attr('class').split(' ')[0];
    $('.' + wordID).removeClass('highlighted');
  });
});
