require 'rails_helper'

RSpec.describe Answer do
  it { should validate_presence_of :body }
  it { should belong_to :question }
  it { should belong_to :user }

  describe 'has scope my-answers' do
    let(:user){ create :user_with_questions, with_test_answers: true }
    it 'with only my answers' do
      create :user_with_questions, with_test_answers: true
      expect(Answer.my(user)).to match_array(user.answers)

    end
  end

end

