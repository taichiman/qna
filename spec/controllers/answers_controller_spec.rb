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

  describe 'GET#my-answers' do

    context 'when authenticated' do
      sign_in_user(:user_with_questions, with_test_answers: true)

      before do
        create :user_with_questions, with_test_answers: true #some alien answers for mass        
        get :index
      end

      context 'when I have answers' do
        it 'assigns @answers with all my answers' do
          expect(assigns(:answers)).to match_array(Answer.my(user))
        end

        it { should render_template('index') }

      end
    end

    context 'when unauthenticated' do
        it 'redirects to devise LogIn' do
          get :index
          expect(response).to redirect_to(new_user_session_path)
        
        end
    end

  end

  describe 'DELETE#destroy' do
    context 'authenticated user' do
      sign_in_user(:user)

      def delete_request(answer)
        request.env['HTTP_REFERER'] = my_answers_path
        delete :destroy, question_id: answer.question, id: answer
      end

      context 'when owner' do
        let(:answer){ create :answer, user: user }
        before do |e| 
          delete_request(answer) unless e.metadata[:skip_request]
        end

        it 'should delete', skip_request: true do  
          expect{ delete_request(answer) }.to change{ 
            Answer.exists?(answer.id) 
          }.from(true).to(false) 
          
        end

        it { should redirect_to(my_answers_path) }
        it { should set_flash[:notice].to(t('answers.destroy.deleted')) }

      end

      context 'when not owner' do
        it 'when not owner of answer should not delete' do
          answer = create :answer

          expect{ delete_request(answer) }.not_to change{ 
            Answer.exists?(answer.id) 
          }

        end

      end
    end
    
    context 'no authenticated user' do
      let(:answer){ create :answer }
      before do
        sign_out :user
        delete :destroy, id: question, question_id: answer.question
      end    
      
      it { should redirect_to(new_user_session_path) }
      it { should set_flash[:alert].to(t('.devise.failure.unauthenticated')) }
     
    end
  end

end

