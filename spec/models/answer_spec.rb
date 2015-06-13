require 'rails_helper'

RSpec.describe Answer do
  it { should validate_presence_of :body }
  it { should belong_to :question }
  it { should belong_to :user }

  describe 'has scope - My answers' do
    let(:user){ create :user_with_questions, with_test_answers: true }
    it 'with only my answers' do
      create :user_with_questions, with_test_answers: true
      expect(Answer.my(user)).to match_array(user.answers)

    end
  end

  describe 'has scope - Best Answer' do
    let(:question){ create :question_with_answers, answers_count: 3 }
    
    it 'return answer' do
      question.answers.first.select_as_best

      expect(Answer.best_answer(question)).to match_array(question.answers.first)

    end
  end

  describe 'select best answer' do
    let(:question){ create :question_with_answers, answers_count: 4 }

    describe 'selecting instance method' do
      let(:answer){ create :answer }

      it { expect(answer.respond_to?(:select_as_best)).to eq true }

    end

    context 'when no answer was selected before' do
      let(:answer){ question.answers.second }
      
      it 'selects answer as best' do
        
        expect{ answer.select_as_best }
        .to change(answer.reload,:best).from(false).to(true)

      end

    end

    context 'when an answer was selected already' do
      let(:selected_answer){ question.answers.first }
      let(:new_best_answer){ question.answers.second }

      it 'deselects old best'  do
        selected_answer.update(best: true)
        new_best_answer.select_as_best
        expect(selected_answer.reload.best). to eq false

      end

      it 'selects new as best'  do
        selected_answer.update(best: true)

        expect{ new_best_answer.select_as_best }
        .to change(new_best_answer.reload, :best).from(false).to(true)

      end

      it 'another answers, not touched'  do
        selected_answer.update(best: true)
        new_best_answer.select_as_best

        #TODO to scope
        expect(Answer.where(best: true)).to match_array([new_best_answer])

      end
      
    end

    describe 'a various cases' do
      let(:answer){ question.answers.first }

      it 'selects same answer as best ' do
        answer.update(best: false)
        answer.select_as_best
        expect(answer.reload.best).to eq true
      end

      it 'unselects same answer' do
        answer.update(best: true)
        answer.select_as_best
        expect(answer.reload.best).to eq false
      end

    end
  end

end

