class VotesController < ApplicationController
  before_action :set_question

  def vote_up
    current_user.votes.create votable: @question
    
    render nothing: true
  end

  private

  def set_question
    @question = Question.find(params[:id])

  end

end

