require 'rails_helper'

describe AnswersController do
  let(:question) { create :question }
  
  shared_examples 'only owner handling answer' do |message|
    let(:answer){ create :answer }

    it { should redirect_to my_answers_path }
    it { should set_flash[:alert].to(t(message[:message])) }

  end

  shared_examples 'redirected to devise SignIn page' do
    it { should redirect_to(new_user_session_path) }
    it { should set_flash[:alert].to(t('.devise.failure.unauthenticated')) }
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
  
  describe 'GET #edit' do
    context 'when authenticated' do
      sign_in_user
      let(:answer){ create(:answer, user: user) }

      before do
        get :edit, question_id: answer.question, id: answer
      end

      context 'owner' do
        it 'should assign @answer' do
          expect(assigns(:answer)).to eq(answer)
        end
        it { should render_template 'edit' }
      end

      context 'not owner' do
        it_behaves_like 'only owner handling answer', message: 'not-owner-of-answer'
      end
    end
    
    context 'when unauthenticated' do        
      let(:answer){ create :answer }

      before do
        sign_out :user
        get :edit, question_id: answer.question, id: answer
      end

      it_behaves_like 'redirected to devise SignIn page'

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

  describe 'PATCH#update' do
    def patch_request
      patch :update, 
        question_id: answer.question, 
        id: answer, 
        answer: { body: body_attribute.upcase }

    end

    def body
      answer.reload.body
    end
    
    let(:answer){ create(:answer, user: user) }
    let(:body_attribute){ answer.body }

    describe 'user authenticated' do
      sign_in_user

      before do |example|
        unless example.metadata[:skip_request]
          patch_request
        end
      end

      context 'owner' do

        context 'updates with valid data' do
          it 'assigns @answer' do
            expect(assigns(:answer)).to eq(answer)
          end
          
          it { should redirect_to(question_path(answer.question)) }

          it 'should be able', skip_request: true do
            expect{ patch_request }.to change{ body }.from(body).to(body.upcase)
          end

        end

        context 'updates with invalid data' do
          let(:body_attribute){ '' }

          it { should render_template(:edit) }
          it 'should not be able', skip_request: true do
            expect{ patch_request }.to_not change{ body }
          end

        end
      end

      context 'not owner' do
        let(:answer){ create(:answer) }
        let(:body_attribute){ answer.body }

        it 'should not update', skip_request: true do
          expect{ patch_request }.to_not change{ body }
        end

        it_behaves_like 'only owner handling answer', message: 'not-owner-of-answer'

      end
    end

    describe 'user unauthenticated' do
      let(:answer){ create :answer }

      before do
        patch_request
      end
      it_behaves_like 'redirected to devise SignIn page'

    end 
    
  end

  describe 'DELETE#destroy' do
    context 'authenticated user' do
      sign_in_user(:user)

      def delete_request(answer)
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

        it { should redirect_to(question_path(answer.question)) }
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
      
      it_behaves_like 'redirected to devise SignIn page'
     
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
      before do
        get :index
      end
      it_behaves_like 'redirected to devise SignIn page'

    end
  end

end

