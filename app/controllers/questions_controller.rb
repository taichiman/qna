class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :only_owner, only: [:update, :destroy] 

  def index
    @questions = Question.send *(params[:scope] == 'my' ? [:my, current_user] : :all)

  end

  def show
    @answer = Answer.new
    @answers = @question.answers.order(created_at: :desc)
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
  
  private

  def question_params
    params.require(:question).permit(:title, :body)

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

