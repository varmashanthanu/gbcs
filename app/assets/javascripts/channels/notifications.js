App.notifications = App.cable.subscriptions.create("NotificationsChannel",{
    connected: function(){

    },
    disconnected: function(){

    },
    received: function(data){
        $("#notifications").prepend(data.html);
        if($('#notifications').is(':empty')){
            $('#notif-dropdown').css('color','white');
            $('#notif-icon').css('background-color','white');
            // $('#nav-toggle span').css('background-color','white');
        }
        else {
            $('#no-notifications').empty();
            $('#notif-dropdown').css('color','orangered');
            $('#notif-icon').css('background-color','orangered');
            // $('#nav-toggle span').css('background-color','orangered');
        }
    }
});

$(document).ready(function(){
    if($('#notifications').is(':empty')){
        $('#notif-dropdown').css('color','white');
        $('#notif-icon').css('background-color','white');
        // $('#nav-toggle span').css('background-color','white');
    }
    else {
        $('#no-notifications').empty();
        $('#notif-dropdown').css('color','orangered');
        $('#notif-icon').css('background-color','orangered');
        // $('#nav-toggle span').css('background-color','orangered');
    }
    $('#notif-dropdown').click(function(){
        $('#notif-dropdown').css('color','white');
        $('#notif-icon').css('background-color','white');
        // $('#nav-toggle span').css('background-color','white');
    });
});