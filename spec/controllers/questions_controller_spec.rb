require 'rails_helper'

describe QuestionsController do
  describe 'GET #new' do
    before { get :new }

    it 'should creates instance variable' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'should renders new view' do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context 'with valid attributes' do
      it 'creates a question' do
        expect{ post :create, question: attributes_for(:question) }.to change(Question,:count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to(question_path(assigns(:question)))
      end
    end

    context 'with invalid attributes' do
      it 'does not create the question' do
        expect{ post :create, question: attributes_for(:invalid_question) }.to_not change(Question,:count)
      end
      it 'renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end
end