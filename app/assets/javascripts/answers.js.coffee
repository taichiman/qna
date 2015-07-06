$ ->
  $('a.edit-answer-link')
  .click (e) ->
    e.preventDefault()
    answer_id = $(this).data('answerId')
    $('form#edit_answer_' + answer_id).show()

