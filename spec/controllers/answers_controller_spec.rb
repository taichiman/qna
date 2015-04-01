require 'rails_helper'

describe AnswersController do
  describe 'GET #new' do
    let(:question) { create :question }

    before do
      get(:new, question_id: question.id)
    end

    it 'assigns the question to @question' do
      expect(assigns(:question)).to eql(question)
    end

    it 'assigns a new record to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'assigns the question to @question' do
        question = create(:question)
        post :create,
          question_id: question.id,
          answer: attributes_for(:answer)

        expect(assigns (:question)).to eql(question)
      end

      it 'creates an answer' do
        question = create :question
        expect{ post :create,
                  question_id: question.id,
                  answer: attributes_for(:answer)

        }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show answer' do
        question = create(:question)
        post :create,
          question_id: question.id,
          answer: attributes_for(:answer)

        should redirect_to(question_path(question))
      end
    end

    context 'with invalid attributes' do
      let(:question){ create(:question) }

      it 'does not create an answer' do
        expect{ post :create,
                  question_id: question.id,
                  answer: attributes_for(:answer, body: nil)

        }.not_to change{ question.answers.count }
      end

      it 're-renders new view' do
        post :create,
          question_id: question.id,
          answer: attributes_for(:answer, body: nil)

        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #show" do
    let(:question) { create :question_with_answers }
    let(:answer) { question.answers[1] }

    before do
      get(:show,
        question_id: question,
        id: answer
      )
    end

    it "assigns @question" do
      expect(assigns(:question)).to be_eql(question)
    end

    it "assigns @answer" do
      expect(assigns(:answer)).to be_eql(answer)
    end

    it "render template :show" do
      expect(response).to render_template(:show)
    end
  end
end
