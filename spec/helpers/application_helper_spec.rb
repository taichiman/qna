require 'rails_helper'

describe ApplicationHelper do

  it 'should shows name of user' do
    user = create 'user'

    expect(user_name(user)).to eq(user.email.partition('@').first)

  end


  describe 'returns vote state css class for current user' do
    let(:user) { create :user }
    let(:question) { create :question }

    before do
      allow(helper).to receive(:current_user) { user }
    end

    context 'for up-vote button' do
      it 'when there was up vote' do
        vote = create :vote, votable: question, user: user, vote_type: 'up'
        expect(helper.up_vote_css(question)).to eq('vote-up-on')

      end

      it 'when there was not any vote' do
        expect(helper.up_vote_css(question)).to eq('vote-up-off')

      end

      it 'when user not authenticated' do
        allow(helper).to receive(:current_user) { nil }

        expect{ helper.up_vote_css(question) }.to_not raise_exception

      end

    end

    context 'for down-vote button' do
      it 'when there was down vote' do
        vote = create :vote, votable: question, user: user, vote_type: 'down'
        expect(helper.down_vote_css(question)).to eq('vote-down-on')

      end

      it 'when there was not any vote' do
        expect(helper.down_vote_css(question)).to eq('vote-down-off')

      end

      it 'when user not authenticated' do
        allow(helper).to receive(:current_user) { nil }

        expect{ helper.down_vote_css(question) }.to_not raise_exception

      end

    end

  end

end

