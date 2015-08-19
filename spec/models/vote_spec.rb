require 'rails_helper'

describe Vote do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:votable) }

  describe 'result votes calculation' do
    it 'can return negative result' do
      question = create :question

      1.upto 2 do
        create :vote, votable: question, vote_type: 'up'
      end

      1.upto 3 do
        create :vote, votable: question, vote_type: 'down'
      end
      
      expect(Vote.vote_result(question)).to eq(-1)
      
    end

    it 'can return positive result' do
      question = create :question

      1.upto 3 do
        create :vote, votable: question, vote_type: 'up'
      end

      1.upto 2 do
        create :vote, votable: question, vote_type: 'down'
      end
      
      expect(Vote.vote_result(question)).to eq(1)
      
    end

    it 'can return zero result of votes' do
      question = create :question

      1.upto 2 do
        create :vote, votable: question, vote_type: 'up'
      end

      1.upto 2 do
        create :vote, votable: question, vote_type: 'down'
      end
      
      expect(Vote.vote_result(question)).to eq(0)
      
    end

    it 'can return negative result if no "up" votes' do
      question = create :question

      1.upto 2 do
        create :vote, votable: question, vote_type: 'up'
      end

      expect(Vote.vote_result(question)).to eq(2)
      
    end

    it 'can return positive result if no "down" votes' do
      question = create :question

      1.upto 2 do
        create :vote, votable: question, vote_type: 'up'
      end

      expect(Vote.vote_result(question)).to eq(2)
      
    end

  end
end

