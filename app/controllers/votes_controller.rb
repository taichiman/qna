class VotesController < ApplicationController
  before_action :authenticate_user!, :set_question

  def vote_up
    current_user.votes.create!(votable: @question, vote_type: 'up')
    
    s = { vote_up: 1 , vote_count: 1 }

    render json: s

  end

  def vote_down
    

  end

  private

  def set_question
    @question = Question.find(params[:id])

  end

end

