/**
 * Created by Zero on 6/5/17.
 */


jQuery(function($) {
    $(".admin-select").click(function () {
        $(".hidden").toggle();
        $(".admin-select").toggle();
    });

    $(".cancel").click(function(){
        $(".hidden").toggle();
        $(".admin-select").toggle();
    });

    $(".enter").click(function(){
       var $pass = $("#password").val();
        $.ajax({
            type:"GET",
            url:"/users/make_admin",
            dataType:"json",
            data: {password: $pass},
            success:function(result){
                $('#admin-set').val(result);
                if(result){alert('Admin Role Accepted.');
                $(".hidden").toggle();}
                else {alert('Incorrect Admin Password.');}
            }
        })
    });
});