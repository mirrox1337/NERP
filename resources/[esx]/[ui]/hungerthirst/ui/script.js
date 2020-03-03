
$(document).ready(function(){

  window.addEventListener("message", function(event){
    if (event.data.action == "updateStatus"){
      updateStatus(event.data.status);
    }else if (event.data.action == "updateImage"){
      updateImage(event.data.mugshotStr)
    }
    else if (event.data.action == "toggle"){
			if (event.data.show){
				$('#ui').show();
			} else{
				$('#ui').hide();
      }
    }
  });
  
  function updateStatus(status){
    var hunger = status[0]
    var thirst = status[1]
    var drunk = status[2]
    var drug = status[3]
    setProgress(hunger.percent,'.progress-hunger');
    setProgress(thirst.percent,'.progress-thirst');
    setProgress(drunk.percent,'.progress-drunk');
    setProgress(drug.percent,'.progress-drug');
  }
  function updateImage(mugshotStr){
   $('#profileimage img').attr('src', mugshotStr);
  }	
  // Functions
  // Update health/thirst bars
  function setProgress(percent, element){
    $(element).width(percent);
  }

  // Clock based on user's local hour
  function updateClock() {
    var now = new Date(),
        time = (now.getHours()<10?'0':'') + now.getHours() + ':' + (now.getMinutes()<10?'0':'') + now.getMinutes();

    document.getElementById('hour').innerHTML = [time];
    setTimeout(updateClock, 1000);
  }
  updateClock();

});
