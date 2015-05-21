class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :only_owner, only: [:edit, :update, :destroy] 

  def index
    if params[:scope] == 'my' then
      @questions = Question.my(current_user)
      render 'my_index'
    else
      @questions = Question.all
    end

  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new

  end

  def edit; end

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

  def destroy
    #  params: {"authenticity_token"=>"tD5DlBbcCN/ZTk6COssYZowvQAK93zPsWe1wcRlb5ztVgsCFVYkCx4RI//B8YPWVndaOglJt+A5fjBB2R56r0g==",
    #           "id"=>"8"}

    @question.destroy

  rescue ActiveRecord::DeleteRestrictionError
    message = { alert: t('.not-deleted') }  
  else
    message = { notice: t('.deleted') }    
  ensure
    redirect_to my_questions_path, message
  end
  
  private

  def question_params
    params.require(:question).permit(:title, :body)

  end

  def set_question
    @question = Question.find(params[:id])

  end

  def only_owner
    unless @question.user_id == current_user.id
      message = 
        case action_name.to_sym
        when :edit, :update
          'question-not-owner'
        else
          '.only-owner-can-delete'
        end

      redirect_to my_questions_path, alert: t(message)

      return

    end
  end

end

