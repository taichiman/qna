$ ->
  $('.questions-list')
  .on( 'click', 'a.edit-question-link', 
  (e) ->
    e.preventDefault()
    question_id = $(this).data('questionId')  
    $('form#edit_question_'+question_id).show()
  )


# voting:

#TODO refactoring: mybe it makes sense make one function 
$.fn.extend
  show_error: (xhr) -> 
    response = $.parseJSON(xhr.responseText)
    error_div = $.parseHTML '<div class = "alert vote-alert alert-danger"></div>'
    $(error_div).text(response.error)
    $(this).parents('table').before(error_div)

$.fn.extend
  show_message: (xhr) -> 
    response = $.parseJSON(xhr.responseText)
    message_div = $.parseHTML '<div class = "alert vote-alert alert-success"></div>'
    $(message_div).text(response.message)
    $(this).parents('table').before(message_div)

$.fn.extend
  turn_on_up_vote: ->
    $(this).removeClass('vote-up-off').addClass('vote-up-on')
  turn_off_up_vote: ->
    $(this).removeClass('vote-up-on').addClass('vote-up-off')

  turn_on_down_vote: ->
    $(this).removeClass('vote-down-off').addClass('vote-down-on')
  turn_off_down_vote: ->
    $(this).removeClass('vote-down-on').addClass('vote-down-off')

$ ->
  $('.votecell').bind 'ajax:before' , ->
    $('.vote-alert').remove()

$ ->
  $('a.vote-up')
  .bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $(this).show_message(xhr)
    $(this).siblings('.vote-count-post').text(answer.vote_count)
    switch answer.vote_up
      when 0 then $(this).turn_off_up_vote()
      when 1 then $(this).turn_on_up_vote()

  .bind 'ajax:error', (e, xhr, status, error) ->
     $(this).show_error(xhr) 

$ ->
  $('a.vote-down')
  .bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)

    #TODO bag: do show_message, run only when message is in response
    $(this).show_message(xhr)
    $(this).siblings('.vote-count-post').text(answer.vote_count)

    switch answer.vote_down
      when 0 then $(this).turn_off_down_vote()
      when 1 then $(this).turn_on_down_vote()


  .bind 'ajax:error', (e, xhr, status, error) ->
     $(this).show_error(xhr) 

