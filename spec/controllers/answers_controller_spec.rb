require 'rails_helper'

describe AnswersController do
  describe 'GET #new' do
    before do
      get :new
    end
    it 'assigns a new @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates an answer'
      it 'redirects to show answer'
    end

    context 'with invalid attributes' do
      it 'does not create an answer'
      it 'render new answer view'
    end
  end
end
