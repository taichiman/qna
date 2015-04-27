require 'rails_helper'

describe QuestionsHelper do
  it 'should shows answer legend' do
    [#count, #legend
     [0, "0 #{t(:answer_count_legend).pluralize}"],
     [1, "1 #{t(:answer_count_legend).pluralize(1)}"],
     [2, "2 #{t(:answer_count_legend).pluralize(2)}"]
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

end

