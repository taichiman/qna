require 'rails_helper'

describe WelcomeController do
  describe 'GET#index' do
    before do
      get :index
    end

    it 'assigns @questions' do
      create_pair :question
      expect(assigns(@question)[:questions]).to match_array(Question.all)
    end

    it 'renders index view' do
      expect(response).to render_template(:index)
    end
  end
end
