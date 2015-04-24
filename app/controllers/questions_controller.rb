class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    if params[:scope] == 'my' then
      @questions = Question.my(current_user)
    else
      @questions = Question.all
    end
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to( @question, notice: 'The Question created' )
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

end

