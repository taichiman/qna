$ ->
  $('.questions-list')
  .on( 'click', 'a.edit-question-link', 
  (e) ->
    e.preventDefault()
    question_id = $(this).data('questionId')  
    $('form#edit_question_'+question_id).show()
  )


# voting:

$.fn.extend
  show_error: (xhr) -> 
    response = $.parseJSON(xhr.responseText)
    error_div = $.parseHTML '<div class = "alert vote-alert alert-danger"></div>'
    $(error_div).text(response.error)
    $(this).parents('table').before(error_div)

$.fn.extend
  turn_up_vote: ->
    $(this).removeClass('vote-up-off').addClass('vote-up-on')
  turn_off_up_vote: ->
    $(this).removeClass('vote-up-on').addClass('vote-up-off')

$ ->
  $('.votecell').bind 'ajax:before' , ->
    $('.vote-alert').remove()

$ ->
  $('a.vote-up')
  .bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $(this).siblings('.vote-count-post').text(answer.vote_count)

    if answer.vote_up == 1
      $(this).turn_up_vote()
    else
      $(this).turn_off_up_vote()

  .bind 'ajax:error', (e, xhr, status, error) ->
     $(this).show_error(xhr) 

$ ->
  $('a.vote-down')
  .bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $(this).siblings('.vote-count-post').text(answer.vote_count)
    $(this).removeClass('vote-down-off').addClass('vote-down-on')
  .bind 'ajax:error', (e, xhr, status, error) ->
     $(this).show_error(xhr) 

