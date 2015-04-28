class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update]
  
  def index
    if params[:scope] == 'my' then
      @questions = Question.my(current_user)
    else
      @questions = Question.all
    end

  end

  def show; end

  def new
    @question = Question.new

  end

  def edit; 
    unless @question.user == current_user
      redirect_to my_questions_path, notice: t('question-not-owner')
    end

  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to( @question, notice: 'The Question created' )
    else
      render :new
    end

  end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: t('.succesfully')
    else
      flash[:alert] = t('.unsuccesfully')
      render :edit
    end

  end
  
  private

  def question_params
    params.require(:question).permit(:title, :body)

  end

  def set_question
    @question = Question.find(params[:id])

  end

end

