require 'rails_helper'

describe QuestionsController do
  describe 'GET #new' do
    before { get :new }

    it 'should creates @question' do
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
        expect{ post :create, question: attributes_for(:question, title: nil) }.not_to change{ Question.count }
      end
      it 're-renders new view' do
        post :create, question: attributes_for(:question, title: nil)
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #show" do
    let(:question) { create :question }
    before do
      get :show, id: question
    end

    it "assigns @question" do
      expect(assigns(:question)).to be_eql(question)
    end

    it "render template :show" do
      expect(response).to render_template :show
    end
  end
end