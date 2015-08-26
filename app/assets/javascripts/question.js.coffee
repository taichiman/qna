$ ->
  $('.questions-list')
  .on( 'click', 'a.edit-question-link', 
  (e) ->
    e.preventDefault()
    question_id = $(this).data('questionId')  
    $('form#edit_question_'+question_id).show()
  )

$ ->
  $('.votecell').bind 'ajax:before' , ->
    $('.vote-alert').remove()

$ ->
  $('a.vote-up').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $(this).siblings('.vote-count-post').text(answer.vote_count)
    $(this).removeClass('vote-up-off').addClass('vote-up-on')

$ ->
  $('a.vote-down').bind 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    error_div = $.parseHTML '<div class = "alert vote-alert alert-danger"></div>'
    $(error_div).text(response.error)
    $(this).parents('table').before(error_div)

