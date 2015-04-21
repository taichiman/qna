require 'rails_helper'

describe AnswersController do
  describe 'GET #new' do
    let(:question) { create :question }

    context 'authenticated user' do
      sign_in_user
      before{ get(:new, question_id: question.id) }

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

    context 'unauthenticated user' do
      before{ get :new, question_id: question.id }

      it { should set_flash[:alert].to('You need to sign in or sign up before continuing.') }
      it { should redirect_to(new_user_session_path) }
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

      it 'does not create answer' do
        expect{ post :create,
                  question_id: question.id,
                  answer: attributes_for(:invalid_answer)

        }.not_to change(Answer, :count)
      end

      it 're-renders the new view' do
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

    it "renders template :show" do
      expect(response).to render_template(:show)
    end
  end
end
