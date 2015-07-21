class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :only_owner, only: [:update, :destroy] 

  def index
    @questions = Question.all

  end

  def show
    @answer = Answer.new
    @answers = @question.answers_best_in_first

  end

  def new
    @question = Question.new
    @question.attachments.build

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
    @question.update(question_params)

  end

  def destroy
    #  params: {"authenticity_token"=>"tD5DlBbcCN/ZTk6COssYZowvQAK93zPsWe1wcRlb5ztVgsCFVYkCx4RI//B8YPWVndaOglJt+A5fjBB2R56r0g==",
    #           "id"=>"8"}

    @question.destroy

  rescue ActiveRecord::DeleteRestrictionError
    @message = { type: :danger, text: t('.not-deleted') }  
  else
    @message = { type: :success, text: t('.deleted') }

  end

  def my
    @questions = Question.my(current_user)
    render 'index'

  end
  
  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file])

  end

  def set_question
    @question = Question.find(params[:id])

  end

  def only_owner
    unless @question.user_id == current_user.id
      case action_name.to_sym
      when :update
        render text: t('question-not-owner')
      when :destroy 
        render text: t('.only-owner-can-delete')
      end

    end
  end

end

