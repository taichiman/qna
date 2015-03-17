require 'rails_helper'

describe QuestionsController do
  describe "POST #create" do
    context 'with valid parameters' do
      it 'creates a question' do
        question = FactoryGirl.create
      end

      it 'render show view'
    end

    context 'with invalid parameters' do
      it 'creates a question'
      it 'render new view'
    end
  end
end