require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body  }
  it { should have_many(:answers).dependent(:restrict_with_exception)}
  it { should belong_to(:user) } 

  it { should have_many(:attachments) }
  it { should accept_nested_attributes_for :attachments }

  it { should have_many(:votes) }
  it { should have_many(:vote_users).through(:votes).source(:user) }

  describe 'has scope - Best Answer' do
    let(:question){ create :question_with_answers, answers_count: 3 }
    
    it 'return answer' do
      question.answers.first.select_as_best

      expect(question.best_answer).to match_array(question.answers.first)

    end
  end

  describe 'scope for showing a question answers' do
    let(:question){ create :question_with_answers, answers_count: 3 }
    
    it 'shows all answers for this question' do
      question.answers.last.select_as_best

      expect(question.answers_best_in_first).to match_array(question.answers)
    end

    it 'with best in first position' do
      question.answers.last.select_as_best

      expect(question.answers_best_in_first.first).to eq question.answers.last
    end
  end

  describe 'return vote result' do
    it 'should return 2 positive votes' do
      question = create :question

      1.upto 5 do
        create :vote, votable: question, vote_type: 'up'
      end

      1.upto 3 do
        create :vote, votable: question, vote_type: 'down'
      end
      
      expect(question.result_votes).to eq(2)
      
    end

  end
end
