class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:update, :destroy, :best_answer]
  before_action :only_owner, only: [:update, :destroy]

  def index
    @answers = Answer.my(current_user)
  end

  def create
    attrs = answer_params.merge( user: current_user )
    #TODO delete @question for @answer.question
    @answer = @question.answers.create(attrs)

  end

  def update
    @answer.update_attributes(answer_params)
    @question=@answer.question

  end

  def destroy
    @answer.delete

  end

  def best_answer
    #TODO ref
    if @answer.question.user_id != current_user.id then 
      render text: t('.only-question-owner-can-select-best-answer')
      return

    end

    @new_best = @answer
    @old_best = get_old_best_answer

    if @old_best != @new_best
      @old_best.try(:update, {best: false})
    end
    @new_best.toggle!(:best)

  end

  private

  def answer_params
    params.require(:answer).permit(:body)

  end

  def set_question
    @question = Question.find(params[:question_id])

  end
  
  def set_answer
    @answer = Answer.find(params[:id])

  end

  def only_owner
    unless @answer.user_id == current_user.id
      message = 
        case action_name.to_sym
        when :update
          'not-owner-of-answer'
        when :destroy
          '.only-owner-can-delete'
        end

      render text: t(message)

    end
  end

  def get_old_best_answer
    @answer.question.answers.where(best: true).take
  
  end

end

