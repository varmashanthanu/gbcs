// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.erb.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(function(){
    $('.pagination a').on('click',function(){
        $.get(this.href,null,null,'script');
        return false;
    });
});

$(document).ready(function(){

    $('#filter').click(function(){
        $('.sorter').hide();
        $('.filter').show();
    });

    $('#sorter').click(function(){
        $('.sorter').show();
        $('.filter').hide();
    });
});