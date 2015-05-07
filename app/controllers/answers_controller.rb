class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_question, only: [:new, :show, :create]
  before_action :set_answer, only: [:edit, :show, :destroy]
  before_action :only_owner, only: [:edit, :destroy]

  def index
    @answers = Answer.my(current_user)
  end

  def new 
    @answer = Answer.new
  end

  def edit; end

  def show; end

  def create
    attrs = answer_params.merge( user: current_user )
    @answer = @question.answers.build(attrs)

    if @answer.save
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  def destroy
    @answer.delete 
    redirect_to :back, notice: t('.deleted')
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
    unless @answer.user == current_user
      message = 
        case action_name.to_sym
        when :edit, :update
          'not-owner-of-answer'
        else
          '.only-owner-can-delete'
        end

      redirect_to my_answers_path, alert: t(message)

      return

    end
  end

end

