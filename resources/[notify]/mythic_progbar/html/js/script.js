var cancelledTimer = null;

$('document').ready(function() {
    MythicProgBar = {};

    MythicProgBar.Progress = function(data) {
        clearTimeout(cancelledTimer);
        $("#progress-label").text(data.label + '...');

        $(".progress-container").fadeIn('fast', function() {
            $("#progress-bar").stop().css({"width": 0, "background-color": "rgba(64, 224, 208, 0.9)"}).animate({
              width: '100%'
            }, {
              duration: parseInt(data.duration),
              complete: function() {
                $(".progress-container").fadeOut('fast', function() {
                    $('#progress-bar').removeClass('cancellable');
                    $("#progress-bar").css("width", 0);
                    $.post('http://mythic_progbar/actionFinish', JSON.stringify({
                        })
                    );
                })
              }
            });
        });
    };

    MythicProgBar.ProgressCancel = function() {
        $("#progress-label").text("Avbryten");
        $("#progress-bar").stop().css( {"width": "100%", "background-color": "rgba(255, 0, 0, 0.9)"});
        $('#progress-bar').removeClass('cancellable');

        cancelledTimer = setTimeout(function () {
            $(".progress-container").fadeOut('fast', function() {
                $("#progress-bar").css("width", 0);
                $.post('http://mythic_progbar/actionCancel', JSON.stringify({
                    })
                );
            });
        }, 1000);
    };

    MythicProgBar.CloseUI = function() {
        $('.main-container').fadeOut('fast');
    };
    
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case 'mythic_progress':
                MythicProgBar.Progress(event.data);
                break;
            case 'mythic_progress_cancel':
                MythicProgBar.ProgressCancel();
                break;
        }
    });
});