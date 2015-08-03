require 'rails_helper'

describe VotesController do
  describe 'POST#vote-up' do
    let(:question){ create :question }

    context 'when user authenticated' do
      sign_in_user

      describe 'can create vote-up entity' do
        it 'change Vote count' do
          expect{ xhr :post, :vote_up, id: question.id }
          .to change(Vote,:count)     .from(0).to(1)
   
        end

        it 'new vote record is the question voting' do
          xhr :post, :vote_up, id: question.id

          expect(question.votes.first)
          .to have_attributes(votable_id: question.id, votable_type:'Question', user_id: user.id)

        end
      end
    
    end

    context 'when unauthenticated user' do
      it 'does not change Vote count' do
        sign_out :user

        expect{ xhr :post, :vote_up, id: question.id }
        .to_not change(Vote,:count)
 
      end

    end

  end
end

