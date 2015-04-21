require 'rails_helper'

describe AnswersController do
  let(:question) { create :question }
  
  describe 'GET #new' do
    context 'when authenticated user' do
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

    context 'when unauthenticated user' do
      before{ get :new, question_id: question.id }

      check_set_alert_flash_and_redirect_to?
   end

  end

  describe 'POST #create' do
    context 'when authentificated user' do
      sign_in_user

      context 'with valid attributes' do
        before { post :create,
          question_id: question.id,
          answer: attributes_for(:answer) 
        }

        it 'assigns the question to @question' do
          expect(assigns (:question)).to eql(question)
        end

        it 'creates an answer' do
          expect{ post :create,
                    question_id: question.id,
                    answer: attributes_for(:answer)

          }.to change(question.answers, :count).by(1)
        end

        it 'redirects to show answer' do
          should redirect_to(question_path(question))
        end

      end

      context 'with invalid attributes' do
        before { post :create,
            question_id: question.id,
            answer: attributes_for(:invalid_answer)
        }

        it 'doesn\'t create answer' do
          expect{ post :create,
                    question_id: question.id,
                    answer: attributes_for(:invalid_answer)
          }.not_to change(Answer, :count)
        end

        it { should render_template(:new) }
      end

    end

    context 'when unauthenticated user' do
      before { post :create,
        question_id: question.id,
        answer: attributes_for(:answer) 
      }
      check_set_alert_flash_and_redirect_to?
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
