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
end

