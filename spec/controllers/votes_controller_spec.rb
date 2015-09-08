require 'rails_helper'

describe VotesController do
  describe 'POST#vote-up' do
    let(:question){ create :question }

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
      def go
        xhr :post, :vote_up, id: question.id

      end

      context 'if the user previously voted "down"' do
        before do
          vote = create :vote, votable: question, user: user, vote_type: 'down'

        end

        it "respond with :unprocessable_entity" do
          go
          expect(response).to have_http_status(422)

        end 

        it "json body with error message" do
          go
          expect(JSON.parse(response.body)['error']).to include(t('votes.cancel-previous-vote-suggestion'))

        end 

        it 'the up vote will not created' do
          expect{ xhr :post, :vote_up, id: question.id }
          .to_not change(Vote,:count)

        end

      end

      context 'if the user previously voted "up", then cancel the vote' do
        let!(:vote) { create :vote, votable: question, user: user, vote_type: 'up' }

        it 'respond with :succesfull status' do
          go
          expect(response).to have_http_status :ok

        end

        it 'system should destroy the vote' do
          expect{ go }.to change{ Vote.exists?(vote.id) }
          .from(true).to(false)

        end

        it 'render json \'succesfull cancel vote \' message' do
          go

          expect(response.body).to include(t('votes.success-previous-vote-cancel'))

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

      context 'when user tries to vote "down"' do
        context 'if the user previously voted "up"' do
          it 'the down vote will not created' do
            vote = create :vote, votable: question, user: user, vote_type: 'up'

            expect{ xhr :post, :vote_down, id: question.id }
            .to_not change(Vote,:count)

          end

          it 'renders message to cancel old vote' do
            vote = create :vote, votable: question, user: user, vote_type: 'up'
            xhr :post, :vote_down, id: question.id

            expect(JSON.parse(response.body)['error'])
            .to eq( t('.votes.cancel-previous-vote-suggestion') )
            
          end

        end

      end

    end

  end

end

