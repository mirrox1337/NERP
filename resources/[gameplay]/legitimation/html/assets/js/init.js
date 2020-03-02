$(document).ready(function(){
  // Client listener
  window.addEventListener('message', function(event) {
      if (event.data.action == 'open') {
        var data = event.data.array;
        $('#lastname').text(data.lastname);
        $('#firstname').text(data.firstname);
        $('#sex').text(data.sex.toUpperCase() + '/' + data.sex.toUpperCase());
        $('#height').text( data.height + ' CM');
        var pNumb =  data.dateofbirth.substring(8,12) + data.dateofbirth.substring(0,2) + data.dateofbirth.substring(3,5);
        $('#personnummer').text(data.dateofbirth + '-' + data.lastdigits);
        $('body').show();
      } else if (event.data.action == 'close') {
        $('body').hide();
      }
  });
});
