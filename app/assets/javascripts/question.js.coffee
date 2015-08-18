$ ->
  $('.questions-list')
  .on( 'click', 'a.edit-question-link', 
  (e) ->
    e.preventDefault()
    question_id = $(this).data('questionId')  
    $('form#edit_question_'+question_id).show()
  )

$ ->
  $('a.vote-up').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $(this).siblings('.vote-count-post').text(answer.vote_count)
    $(this).removeClass('vote-up-off').addClass('vote-up-on')

