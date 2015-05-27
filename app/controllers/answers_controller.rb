class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:update, :destroy]
  before_action :only_owner, only: [:update, :destroy]

  def index
    @answers = Answer.my(current_user)
  end

  def create
    attrs = answer_params.merge( user: current_user )
    @answer = @question.answers.create(attrs)

  end

  def update
    @answer.update_attributes(answer_params)
    @question=@answer.question

  end

  def destroy
    @answer.delete

    redirect_to question_path(@answer.question), notice: t('.deleted')

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
        else
          '.only-owner-can-delete'
        end

      redirect_to my_answers_path, alert: t(message)

      return

    end
  end

end

