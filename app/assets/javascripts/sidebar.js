/**
 * Created by Zero on 7/25/17.
 */

$(function(){
   $('#open-side-bar').click(function(){
       $('.sidebar-container').toggle('slide');
       $('#open-side-bar').toggle();
       $('#close-side-bar').toggle();
   });
    $('#close-side-bar').click(function(){
        $('.sidebar-container').toggle('slide');
        $('#open-side-bar').toggle();
        $('#close-side-bar').toggle();
    });
});