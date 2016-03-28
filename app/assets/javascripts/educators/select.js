$(document).ready(function () {
  $('.option').hide();
  $('#access-code').show();
  $('#select').change(function () {
    $('.option').hide();
    $('#'+$(this).val()).show();
  })
});