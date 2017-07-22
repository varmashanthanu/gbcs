App.notifications = App.cable.subscriptions.create("NotificationsChannel",{
    connected: function(){

    },
    disconnected: function(){

    },
    received: function(data){
        $("#notifications").prepend(data.html);
        if($('#notifications').is(':empty')){
            $('#notif-dropdown').css('color','white');
        }
        else {
            $('#no-notifications').empty();
            $('#notif-dropdown').css('color','red');
        }
    }
});

$(document).ready(function(){
    if($('#notifications').is(':empty')){
        $('#notif-dropdown').css('color','white');
    }
    else {
        $('#no-notifications').empty();
        $('#notif-dropdown').css('color','red');
    }
    $('#notif-dropdown').click(function(){
        $('#notif-dropdown').css('color','white');
    });
});