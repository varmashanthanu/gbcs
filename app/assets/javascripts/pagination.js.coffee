jQuery ->
  mult = 1
  if $('#infinite-coffee-scroll').size() > 0
    scroller = $('#infinite-coffee-scroll')

    scroller.on 'scroll', ->
      more_posts_url = $('.pagination .next_page').attr('href')
      if more_posts_url && (scroller[0].scrollHeight - scroller.scrollTop() == scroller.height())
        mult = mult+1.6
        $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
        $.getScript more_posts_url
      return
  return


#      <img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />
#(mult*scroller.height()) - (scroller.height()/4)