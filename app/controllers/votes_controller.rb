class VotesController < ApplicationController
  before_action :authenticate_user!, :set_votable
  before_action :set_votable_vote_state, only: [:vote_up, :vote_down]

  def vote_up
    case @state
    when :no_vote
      current_user.votes.create!(votable: @votable, vote_type: 'up')
      s = { vote_up: 1, vote_down: 0, vote_count: @votable.result_votes  }

    when :down_vote
      #TODO ref error to message
      s = { error: t('votes.cancel-previous-vote-suggestion') }
      status = :unprocessable_entity
      
    when :up_vote
      current_user.up_vote_for(@votable).destroy!
      #TODO ref this line: because it is double
      s = { vote_up: 0, vote_down: 0, vote_count: 0, message: t('votes.success-previous-vote-cancel') }

    end

    render json: s, status: status

  end

  def vote_down
    case @state
    when :no_vote
      current_user.votes.create!(votable: @votable, vote_type: 'down')
      s = { vote_down: 1, vote_count: -1 }

    when :up_vote
      s = { error: t('votes.cancel-previous-vote-suggestion') }
      status = :unprocessable_entity

    when :down_vote
      current_user.down_vote_for(@votable).destroy!
      s = { vote_up: 0, vote_down: 0, vote_count: 0, message: t('votes.success-previous-vote-cancel') }
      
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

