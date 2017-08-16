// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.erb.
// You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready(function(){

    $('.comp-show').click(function(){
        $(this).parent().parent().find('.compatibility').slideToggle();
    });

    var timer;
    $('.round').mouseenter(function(){
        var that = $(this);
        timer = setTimeout(function(){
            that.parent().find('.details').fadeIn();
        },1000);
    }).mouseleave(function(){
        clearTimeout(timer);
        $('.round').parent().find('.details').fadeOut();
    });

    $('.member').draggable({
        revert: 'invalid',
        // helper: 'clone',
        // containment: 'window',
        stop: function(){
            $(this).draggable('option','revert','invalid');
        }
    });
    $('.member').droppable({
        greedy: true,

        // tolerance: 'touch',
        drop: function(event,ui){
            ui.draggable.draggable('option','revert',true);
            $(this).html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />');
        }
    });
    $('.members').droppable({
        accept: '.member',
        greedy: true,
        // tolerance: 'fit',
        over: function(){
            {$(this).css('background-color','rgba(225,143,65,0.2');}
        },
        out: function(){
            $(this).css('background-color','transparent');
        },
        drop: function(event2,ui){
            $(this).css('background-color','transparent');
            var team = $(this).parent().attr('id');
            var user = ui.draggable.attr('id');
            var source = ui.draggable.parent().parent().attr('id');
            if(team===source){
                ui.draggable.draggable('option','revert',true);
                return
            }
            ui.draggable.html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
            $.ajax({
                type: 'POST',
                url: '/teams/transfer',
                data: $.param({old_team:source,new_team:team,user:user})
            })
    }
    });
});