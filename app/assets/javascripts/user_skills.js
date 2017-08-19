// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.erb.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function(){
    $('input.level').on('click', function(){
        $(this).parent().submit();
        $(this).closest('form').submit(function(){
           var valuesToSubmit = $(this).serialize();
           $.ajax({
               type: 'POST',
               url: $(this).attr('action'),
               data: valuesToSubmit,
               dataType: 'JSON'
           })
        });
    });
});