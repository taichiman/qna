class VotesController < ApplicationController
  before_action :authenticate_user!, :set_votable
  before_action :set_votable_vote_state, only: [:vote_up, :vote_down]

  def vote_up
    case @state
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
    case @state
    when :no_vote
      current_user.votes.create!(votable: @votable, vote_type: 'down')
      s = { vote_down: 1 , vote_count: -1 }

    when :up_vote
      s = { error: t('votes.cancel-previous-vote') }
      status = :unprocessable_entity
      
    end

    render json: s, status: status

  end

  private

  def set_votable
    @votable = Question.find(params[:id])

  end

  def set_votable_vote_state
    @state = current_user.vote_state_for @votable

  end
end

