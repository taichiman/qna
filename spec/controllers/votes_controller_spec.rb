require 'rails_helper'

describe VotesController do
  describe 'POST#vote-up' do
    let(:question){ create :question }

    context 'when user authenticated' do
      sign_in_user

      context 'can create vote-up entity' do
        it 'change Vote count' do
          expect{ xhr :post, :vote_up, id: question.id }
          .to change(Vote,:count)
          .from(0).to(1)
   
        end

        it 'new vote record is the question voting' do
          xhr :post, :vote_up, id: question.id

          expect(question.votes.first)
          .to have_attributes(votable_id: question.id, votable_type:'Question', user_id: user.id, vote_type: 'up')

        end
      end

      context 'when user tries to vote "up"' do
        context 'if "down" had voted before' do
          it 'the up vote will not created' do
            vote = create :vote, votable: question, user: user, vote_type: 'down'

            expect{ xhr :post, :vote_up, id: question.id }
            .to_not change(Vote,:count)

          end

        end

      end

      context 'when user tries to vote "down"' do
        context 'if "up" had voted before' do
          it 'the down vote will not created' do
            vote = create :vote, votable: question, user: user, vote_type: 'up'

            expect{ xhr :post, :vote_down, id: question.id }
            .to_not change(Vote,:count)

          end

          it 'renders message to cancel old vote' do
            vote = create :vote, votable: question, user: user, vote_type: 'up'
            xhr :post, :vote_down, id: question.id

            expect(JSON.parse(response.body)['error'])
            .to eq( t('.votes.cancel-previous-vote') )
            
          end

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

  describe 'POST#vote-down' do
    let(:question){ create :question }

    context 'when user authenticated' do
      sign_in_user

      context 'can create vote-down entity' do
        it 'change Vote count' do
          expect{ xhr :post, :vote_down, id: question.id }
          .to change(Vote,:count)
          .from(0).to(1)
   
        end

        it 'new vote record is the question voting' do
          xhr :post, :vote_down, id: question.id

          expect(question.votes.first)
          .to have_attributes(votable_id: question.id, votable_type:'Question', user_id: user.id, vote_type: 'down')

        end
      end
    end
  end

end

