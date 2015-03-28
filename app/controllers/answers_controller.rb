class AnswersController < ApplicationController
  def new
    @question = Question.find params[:question_id]
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)

    if @answer.save
      head :created
    else
      head :forbidden
    end
  end
  
  private
  def answer_params
    params.require(:answer).permit(:body)
  end
end