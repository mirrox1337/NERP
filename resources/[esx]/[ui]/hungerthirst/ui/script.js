$(function(){
	window.addEventListener('message', function(event) {
		if (event.data.action == "updateStatus"){
			updateStatus(event.data.status);
		} else if (event.data.action == "updateHudPosition") {
			updateHudPosition(event.data.value)
		} else if (event.data.action == "setBarStatus") {
			setBarStatus(event.data.values)
		}
		else if (event.data.action == "toggle"){
            if (event.data.show){
                $('#container').show();
            } else{
                $('#container').hide();
            }
        }
	});

});

function updateHudPosition(Minimap) {
	var width = Minimap.width;
	var x = Minimap.left_x;
	var y = Minimap.bottom_y;

	var xCalc = (x * $(window).width());
	var widthCalc = width * $(window).width()+ 2;
	var yCalc = (y * $(window).height()) - 25;

	$('#container').css('left', xCalc + 'px').css('top', yCalc + 'px').css('width', widthCalc + 'px')
}

function updateStatus(status){
	var hunger = status[0];
	var thirst = status[1];

	/* Apply the status */
	$('#foodbar').css('width', hunger.percent+'%');
	$('#thirstbar').css('width', thirst.percent+'%');
}