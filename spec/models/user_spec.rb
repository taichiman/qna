require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:restrict_with_exception) }
  it { should have_many(:answers).dependent(:delete_all) }
  
  it { should have_many(:votes) }
  it { should have_many(:voted_questions).through(:votes) }
  it { should have_many(:voted_answers).through(:votes) }

  describe '#up_vote_for, #down_vote_for scopes for get vote instance' do
    let(:user) { create :user }
    let(:question) { create :question }

    context 'has "up" voted' do
      let(:vote) { create :vote, votable: question, user: user, vote_type: 'up' }

      it 'return "up" vote' do
        expect(user.up_vote_for(vote.votable)).to eq(vote)
        
      end

    end

    context 'has "down" voted' do
      let(:vote) { create :vote, votable: question, user: user, vote_type: 'down' }

      it 'return "down" vote' do
        expect(user.down_vote_for(vote.votable)).to eq(vote)
        
      end

    end

    context 'has no vote voted' do
      it 'return nil' do
        expect(user.up_vote_for(question)).to be_nil
        expect(user.down_vote_for(question)).to be_nil
        
      end

    end

  end
  
  describe 'check owning' do
    let(:not_owner_user){ create :user }

    context 'for question' do
      let(:question){ create :question }
      let(:user){ question.user }

      it 'true when owner' do
        expect(user.owner_of?(question)).to be_truthy
      end

      it 'false when not owner' do
        expect(not_owner_user.owner_of?(question)).to be_falsy
      end
    
    end

    context 'for answer' do
      let(:answer){ create :answer }
      let(:user){ answer.user }

      it 'true when owner' do
        expect(user.owner_of?(answer)).to be_truthy
      end

      it 'false when not owner' do
        expect(not_owner_user.owner_of?(answer)).to be_falsy
      end
    
    end

  end

  describe 'check whether the user has voted' do
    context 'for question' do
      it 'user voted up' do
        user = create :user
        question = create :question
        create :vote, votable: question, vote_type: 'up', user: user

        expect(user.voted_up_on?(question)).to be_truthy

      end

      it 'user did not up vote' do
        user = create :user
        question = create :question

        expect(user.voted_up_on?(question)).to be_falsey

      end

      it 'user voted down' do
        user = create :user
        question = create :question
        create :vote, votable: question, vote_type: 'down', user: user

        expect(user.voted_down_on?(question)).to be_truthy

      end

    end
  end

  describe 'the user vote state for the votable' do
    let(:user) { create :user }
    let(:question) { create :question }

    context 'when votable has up vote' do
      it 'return :up_vote' do
        create :vote, user: user, votable: question, vote_type: 'up'
        expect(user.vote_state_for(question)).to eq(:up_vote)
      end
    end

    context 'has down vote' do
      it 'return :down_vote' do
        create :vote, user: user, votable: question, vote_type: 'down'
        expect(user.vote_state_for(question)).to eq(:down_vote)
      end

    end

    context 'has not any vote' do
      it 'return :no_vote' do
        expect(user.vote_state_for(question)).to eq(:no_vote)
      end

    end

  end

end

