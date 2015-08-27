require 'rails_helper'

describe Vote do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:votable) }
  it { should validate_inclusion_of(:vote_type).in_array(%w(up down)) }

  describe 'result votes calculation' do
    it 'can return negative result' do
      question = create :question

      1.upto 2 do
        create :vote, votable: question, vote_type: 'up'
      end

      1.upto 3 do
        create :vote, votable: question, vote_type: 'down'
      end
      
      expect(Vote.result_votes(question)).to eq(-1)
      
    end

    it 'can return positive result' do
      question = create :question

      1.upto 3 do
        create :vote, votable: question, vote_type: 'up'
      end

      1.upto 2 do
        create :vote, votable: question, vote_type: 'down'
      end
      
      expect(Vote.result_votes(question)).to eq(1)
      
    end

    it 'can return zero result of votes' do
      question = create :question

      1.upto 2 do
        create :vote, votable: question, vote_type: 'up'
      end

      1.upto 2 do
        create :vote, votable: question, vote_type: 'down'
      end
      
      expect(Vote.result_votes(question)).to eq(0)
      
    end

    it 'can return negative result if no "up" votes' do
      question = create :question

      1.upto 2 do
        create :vote, votable: question, vote_type: 'up'
      end

      expect(Vote.result_votes(question)).to eq(2)
      
    end

    it 'can return positive result if no "down" votes' do
      question = create :question

      1.upto 2 do
        create :vote, votable: question, vote_type: 'up'
      end

      expect(Vote.result_votes(question)).to eq(2)
      
    end

  end

  describe '::vote_state return state of vote for a votable entity' do
    context 'for question' do
      let(:question) { create :question }
      let(:user) { create :user }

      before do
        allow(Vote).to receive(:current_user) { user }
      end

      it 'when votable was up voted returns :up_vote' do
        vote = create :vote, votable: question, user: user, vote_type: 'up'
        expect(Vote.vote_state(question)).to eq(:up_vote)

      end

      it 'when votable was down voted returns :down_vote' do
        vote = create :vote, votable: question, user: user, vote_type: 'down'
        expect(Vote.vote_state(question)).to eq(:down_vote)

      end

      it 'when votable was not voted returns :no_vote' do
        expect(Vote.vote_state(question)).to eq(:no_vote)

      end


    end

  end

end

