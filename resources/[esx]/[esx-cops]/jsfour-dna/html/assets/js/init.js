$(document).ready(function(){
  window.addEventListener('message', function(event) {
      if (event.data.action == 'open') {
        $('#wrapper').show();
      } else if (event.data.action == 'close') {
        $('#wrapper').hide();
      } else if (event.data.action == 'callback') {
        if (event.data.array == 'upload-fail') {
          $('#upload h1').text('You have no DNA..');
          $('.progress').hide();
        } else if (event.data.array == 'upload-success') {
          var txt;
          if (event.data.atype == 'murder') {
            txt = 'You have uploaded the DNA with ID: ' + event.data.value;
          } else {
            txt = 'You have uploaded the DNA for ' + event.data.value;
          }
		  setTimeout(function(){
			  $('#upload h1').text('Done!');
			  $('.progress').hide();
			  $('.upload-success').text(txt);
		   }, 3000);
        } else if (event.data.array == 'upload-failed') {
          setTimeout(function(){
            $('#upload h1').text('The person is already in our system..');
            $('.progress').hide();
          }, 3000);
        } else if (event.data.array == 'match-fail') {
          $('#match-message').css('background', '#ae0e00');
          $('#match-message').text('No match..').slideDown().show();
          setTimeout(function(){
            $('#match-message').slideUp();
          }, 3000);
        } else if (event.data.array == 'match-exists') {
          $('#match-message').css('background', '#ae0e00');
          $('#match-message').text("There's already a match..").slideDown().show();
          setTimeout(function(){
            $('#match-message').slideUp();
          }, 3000);
        } else if (event.data.array == 'match-success') {
          $('#match-message').css('background', '#00ae22');
          $('#match-message').text('We have a match! Sending lab report..').slideDown().show();
          setTimeout(function(){
            $('#match-message').slideUp();
          }, 3000);
        } else if (event.data.array == 'search-fail') {
          $('#match-message').css('background', '#ae0e00');
          $('#match-message').text("Couldn't find the ID in the database").slideDown().show();
          setTimeout(function(){
            $('#match-message').slideUp();
          }, 3000);
        } else if (event.data.array == 'remove-success') {
          $('#remove-message').css('background', '#00ae22');
          $('#remove-message').text('DNA removed!').slideDown().show();
          setTimeout(function(){
            $('#remove-message').slideUp();
          }, 3000);
        } else if (event.data.array == 'remove-fail') {
          $('#remove-message').css('background', '#ae0e00');
          $('#remove-message').text("Couldn't find the DNA..").slideDown().show();
          setTimeout(function(){
            $('#remove-message').slideUp();
          }, 3000);
        }
      } else if (event.data.action == 'murder') {
        if (event.data.array.pk != 'tomt') {
          for (var i = 0; i < event.data.array.length; i++) {
            $('#brottsplatser ul').append('<li><img src="assets/images/dna.png"/><p class="id">'+event.data.array[i].pk+'</p><p>Uploaded by:</p><p>'+event.data.array[i].uploader+'</p><p>'+event.data.array[i].datum+'</p></li>');
          }
        } else {
          $('#database h1').text('No results..');
        }
      } else if (event.data.action == 'prov') {
        if (event.data.array.pk != 'tomt') {
          for (var i = 0; i < event.data.array.length; i++) {
            $('#personer ul').append('<li><img src="assets/images/dna.png"/><p class="id">'+event.data.array[i].killer+'</p><p>Uploaded by:</p><p>'+event.data.array[i].uploader+'</p><p>'+event.data.array[i].datum+'</p></li>');
          }
        } else {
          $('#database h1').text('No results..');
        }
      } else if (event.data.action == 'match') {
        if (event.data.array.pk != 'tomt') {
          for (var i = 0; i < event.data.array.length; i++) {
            $('#lab ul').append('<li><img src="assets/images/dna.png"/><p class="id">'+event.data.array[i].pk+'</p><p>Found traces of DNA from</p><p>'+event.data.array[i].killer+'</p></li>');
          }
          $('#lab h1').text('Lab reports');
        } else {
          $('#lab h1').text('No results..');
        }
      }
  });

function resetAll() {
  $('#database h1').text('Database');
  $('#upload h1').text('Uploading..');
  $('.upload-success').text('');
  $('.progress').show();
  $('#upload').hide();
  $('#match').hide();
  $('#match-message').hide();
  $('#remove').hide();
  $('#remove-password').val('');
  $('#remove-id').val('');
  $('#remove-message').hide();
  $('#lab').hide();
  $('#database').hide();
  $('#brottsplatser').hide();
  $('#personer').hide();
  $('#brottsplatser ul').html('');
  $('#personer ul').html('');
  $('#lab ul').html('');
  $('#match-input').val('');
  $('#home').show();
}

$('.btn-back').click(function(){
  resetAll()
});
  $('#btn-upload').click(function() {
    $('#home').hide();
    $('#upload').show();
    $.post('http://jsfour-dna/upload', JSON.stringify({}));
  });

  $('#btn-match').click(function() {
    $('#home').hide();
    $('#match').show();
  });

  $('#btn-remove').click(function() {
    $('#home').hide();
    $('#remove').show();
  });

  $('#btn-remove-go').click(function() {
    if ($('#remove-password').val() == 'polisen') {
      if ($('#remove-id').val() != '') {
        if (parseInt($('#remove-id').val())) {
          if ($('#remove-id').val().includes("#m")) {
            $.post('http://jsfour-dna/remove', JSON.stringify({match: $('#remove-id').val()}));
          } else {
            $.post('http://jsfour-dna/remove', JSON.stringify({id: $('#remove-id').val()}));
          }
        } else {
          $.post('http://jsfour-dna/remove', JSON.stringify({name: $('#remove-id').val()}));
        }
      }
    } else {
      $('#remove-message').css('background', '#ae0e00');
      $('#remove-message').text('Wrong password').slideDown().show();
      setTimeout(function(){
        $('#remove-message').slideUp();
      }, 3000);
    }
  });

  $('#btn-match-go').click(function() {
    if ($('#match-input').val() != '') {
      $.post('http://jsfour-dna/match', JSON.stringify({id: $('#match-input').val()}));
    }
  });

  $('#btn-lab').click(function() {
    $('#home').hide();
    console.log("JS FETCH");
    $.post('http://jsfour-dna/fetch', JSON.stringify({type: "match"}));
    $('#lab').show();
  });

  $('#btn-brottsplatser').click(function() {
    $('#home').hide();
    $.post('http://jsfour-dna/fetch', JSON.stringify({type: "murder"}));
    $('#database h1').text('Database - Crime scenes');
    $('#database').show();
    $('#brottsplatser').show();
  });

  $('#btn-personer').click(function() {
    $('#home').hide();
    $.post('http://jsfour-dna/fetch', JSON.stringify({type: "prov"}));
    $('#database h1').text('Database - Persons');
    $('#database').show();
    $('#personer').show();
  });

  $(document).keyup(function(e) {
     if (e.keyCode == 27) {
       $('#wrapper').hide();
       resetAll()
       $.post('http://jsfour-dna/escape', JSON.stringify({}));
    }
  });
});
