require 'rails_helper'

describe QuestionsController do
  describe "GET #index" do
    let(:questions) { create_list(:question, 2) }

    before do
      get :index
    end

    it "populates an array of all questions" do
        expect(assigns(:questions)).to match_array(questions)
    end

    it "renders index view" do
        expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'should creates instance variable' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'should renders new view' do
      expect(response).to(render_template :new)
    end
  end

  describe "POST #create" do
    context 'with valid parameters' do
      it 'creates a question' do
        expect{ post :create, question: attributes_for(:question) }.to change(Question,:count).by(1)
      end
      
      # it { 
      #   post :create, question: attributes_for(:question)
      #   should render_template('show') 
      # }


      it 'render show view' do

      end
    end

    context 'with invalid parameters' do
      it 'creates a question'
      it 'ender new view'
    end
  end
end