require 'rails_helper'

describe VotesController do
  describe 'POST#vote-up' do
    let(:question){ create :question }

    it 'can create vote-up entity' do
      xhr :post, :vote_up, id: question.id

      expect(question.votes.first).to be_eq Vote.first 

    end

  end
end

