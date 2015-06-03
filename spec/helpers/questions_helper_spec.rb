require 'rails_helper'

describe QuestionsHelper do
  it 'should shows answer legend' do
    [#count, #legend
     [0, "0 #{t('answer-count-legend').pluralize}"],
     [1, "1 #{t('answer-count-legend').pluralize(1)}"],
     [2, "2 #{t('answer-count-legend').pluralize(2)}"]
    ].each do |count, legend|
      expect(answer_count_legend(count)).to eq(legend)
    end
  
  end

  describe 'shows count of my questions' do
    it 'there are some questions' do
      user = create :user_with_questions
      expect(my_questions_count(user)).to eq(" (#{Question.my(user).count})")

    end

    it 'there are no questions' do
      user = create :user_with_questions, questions_count: 0
      expect(my_questions_count(user)).to eq('')
    
    end

  end

  describe 'count of my answers' do

    context 'some answers are answered' do
      let(:user){ create :user_with_questions, with_test_answers: true }

      it 'returns its number' do
        expect(my_answers_count(user)).to eq(" (#{user.answers.count})")
      end

    end

    context 'when no answer was given' do
      let(:user){ create(:user) }

      it 'be empty' do
        expect(my_answers_count(user)).to be_empty

      end

    end

  end

  describe 'check question owning' do
    let(:question){ create :question }
    context 'for logined user' do
      before{ allow_any_instance_of(subject).to receive(:current_user){ question.user } } 

      it 'true when owner' do
        expect(question_owner?(question)).to be_truthy
      end

      it 'false when not owner' do
        expect(question_owner?(create :question)).to be_falsy
      end
      
    end
    
    context 'for unauthenticated user' do
      before{ allow_any_instance_of(subject).to receive(:current_user){ nil } } 
    
      it 'false when owner' do
        expect(question_owner?(question)).to be_falsy

      end 

      it 'false when not owner' do
        expect(question_owner?(question)).to be_falsy
   
      end

    end

  end

end

