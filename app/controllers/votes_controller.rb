class VotesController < ApplicationController
  before_action :authenticate_user!, :set_votable

  def vote_up
    state = current_user.vote_state_for @votable

    case state
    when :no_vote
      current_user.votes.create!(votable: @votable, vote_type: 'up')
      s = { vote_up: 1 , vote_count: 1 }

    when :down_vote
      s = { error: t('votes.cancel-previous-vote') }
      status = :unprocessable_entity
      
    end

    render json: s, status: status

  end

  def vote_down
    s = { error: t('votes.cancel-previous-vote') }
    render json: s, status: :unprocessable_entity

  end

  private

  def set_votable
    @votable = Question.find(params[:id])

  end

end

