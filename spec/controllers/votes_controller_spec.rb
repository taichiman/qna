require 'rails_helper'

describe VotesController do
  describe 'POST#vote-up' do
    let(:question){ create :question }

    def go_up
      xhr :post, :vote_up, id: question.id

    end

    sign_in_user

    context 'when user tries to vote "up"' do

      context 'if no any vote, then create vote-up entity' do
        it 'change Vote count' do
          expect{ go_up }
          .to change(Vote,:count)
          .from(0).to(1)
   
        end

        it 'new vote record is the question voting' do
          go_up

          expect(question.votes.first)
          .to have_attributes(votable_id: question.id, votable_type:'Question', user_id: user.id, vote_type: 'up')

        end

        it 'increase summary vote result' do
          2.times { create :vote, votable: question, vote_type: 'up' }
          go_up
          binding.pry 
#where are all bellow methods store, and waht its mean
          expect(JSON.parse(response.body)['vote_count']).to eq 3

        end

      end

      context 'if the user previously voted "down", then show cancel vote message' do
        before do
          vote = create :vote, votable: question, user: user, vote_type: 'down'

        end

        it "respond with :unprocessable_entity" do
          go_up
          expect(response).to have_http_status(422)

        end 

        it "json body with error message" do
          go_up
          expect(JSON.parse(response.body)['error']).to include(t('votes.cancel-previous-vote-suggestion'))

        end 

        it 'the up vote will not created' do
          expect{ xhr :post, :vote_up, id: question.id }
          .to_not change(Vote,:count)

        end

        xit 'no change summary vote result'

      end

      context 'if the user previously voted "up", then cancel the vote' do
        let!(:vote) { create :vote, votable: question, user: user, vote_type: 'up' }

        it 'respond with :succesfull status' do
          go_up
          expect(response).to have_http_status :ok

        end

        it 'system should destroy the vote' do
          expect{ go_up }.to change{ Vote.exists?(vote.id) }
          .from(true).to(false)

        end

        it 'render json \'succesfull cancel vote \' message' do
          go_up

          expect(response.body).to include(t('votes.success-previous-vote-cancel'))

        end

        xit 'decrease summary vote result'

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

    def go_down
      xhr :post, :vote_down, id: question.id

    end

    context 'when user authenticated' do
      sign_in_user

      context 'when user tries to vote "down"' do

        context 'if was no vote, then create vote-down entity' do
          it 'change Vote count' do
            expect{ go_down }
            .to change(Vote,:count)
            .from(0).to(1)
     
          end

          it 'new vote record is the question voting' do
            go_down

            expect(question.votes.first)
            .to have_attributes(votable_id: question.id, votable_type:'Question', user_id: user.id, vote_type: 'down')

          end

          xit 'decrease summary vote result'

        end

        context 'if the user previously voted "up", show need cancel message' do
          it 'the down vote will not created' do
            vote = create :vote, votable: question, user: user, vote_type: 'up'

            expect{ go_down }
            .to_not change(Vote,:count)

          end

          it 'renders message to cancel old vote' do
            vote = create :vote, votable: question, user: user, vote_type: 'up'
            go_down

            expect(JSON.parse(response.body)['error'])
            .to eq( t('.votes.cancel-previous-vote-suggestion') )
            
          end

          xit 'no change summary vote result'

        end

        context 'if the user previously voted "down", then cancel the vote' do
          let!(:vote) { create :vote, votable: question, user: user, vote_type: 'down' }

          it 'respond with :succesfull status' do
            go_down
            expect(response).to have_http_status :ok

          end

          it 'system should destroy the vote' do
            expect{ go_down }.to change{ Vote.exists?(vote.id) }
            .from(true).to(false)

          end

          it 'render json \'succesfull cancel vote \' message' do
            go_down

            expect(response.body).to include(t('votes.success-previous-vote-cancel'))

          end

          xit 'increase summary vote result'
        end

      end

    end

  end

end

