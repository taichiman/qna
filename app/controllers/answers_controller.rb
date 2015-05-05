class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_question, only: [:new, :show, :create]

  def index
    @answers = Answer.my(current_user)
  end

  def new 
    @answer = Answer.new
  end

  def show
    @answer = Answer.find(params[:id])
  end

  def create
    attrs = answer_params.merge( user: current_user )
    @answer = @question.answers.build(attrs)

    if @answer.save
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
