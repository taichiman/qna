require 'rails_helper'

describe AnswersController do
  describe 'GET #new' do
    let(:question) {create :question}
    before do
      get :new, {question_id:question.id}
    end
    it 'assigns the question to @question' do
      expect(assigns(:question)).to eql(question)
    end
    it 'assigns a new record to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'assigns the question to @question' do
        question = create :question
        post :create, {question_id: question.id , answer: attributes_for(:answer)}

        expect(assigns(:question)).to eql(question)
      end

      it 'creates an answer' do
        question = create :question
        expect{post :create, {question_id: question.id , answer: attributes_for(:answer)}}.to change(question.answers,:count).by(1)
      end


      xit 'redirects to show answer' do
        question = create :question
        post :create, {question_id: question.id , answer: attributes_for(:answer)}

        should redirect_to( question_answer_path(question, question.answers.last) )
      end
    end

    context 'with invalid attributes' do
      it 'does not create an answer'
      it 'render new answer view'
    end
  end
end
