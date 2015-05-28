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
    let(:answer){ create :answer }

    it "user can not see answer by html request" do
      expect(get: "/questions/#{answer.question.id}/answers/#{answer.id}" ).to_not be_routable

    end

  end

  describe 'GET #edit' do
      let(:answer){ create :answer }

      it "authenticated user can not edit answer by html request" do
        expect(get: "/questions/#{answer.question.id}/answers/#{answer.id}/edit" ).to_not be_routable

      end

  end

  describe 'POST #create' do
    context 'when authentificated user' do
      sign_in_user

      context 'with valid attributes' do
        before { xhr :post, :create,
          question_id: question.id,
          answer: attributes_for(:answer)
        }

        it 'assigns the question to @question' do
          expect(assigns (:question)).to eql(question)
        end

        it 'creates an answer' do
          expect{ xhr :post, :create,
                    question_id: question.id,
                    answer: attributes_for(:answer)

          }.to change(question.answers, :count).by(1)
        end

        it 'render js response' do
          should render_template(:create)

        end
      end

      context 'with invalid attributes' do
        before { xhr :post, :create,
            question_id: question.id,
            answer: attributes_for(:invalid_answer)
        }

        it 'doesn\'t create answer' do
          expect{ xhr :post, :create,
                    question_id: question.id,
                    answer: attributes_for(:invalid_answer)
          }.not_to change(Answer, :count)
        end

        it { should render_template('create') }

      end
    end

    context 'when unauthenticated user' do
      before { xhr :post, :create,
        question_id: question.id,
        answer: attributes_for(:answer) 
      }
      #TODO check_set_alert_flash_and_redirect_to?
    end

  end

  describe 'PATCH#update' do
    def patch_request
      xhr :post, :update, 
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
          
          it 'assigns @question' do
            expect(assigns(:question)).to eq(answer.question)
          end
          
          it { should render_template('update') }

          it 'should be able', skip_request: true do
            expect{ patch_request }.to change{ body }.from(body).to(body.upcase)
          end

        end

        context 'updates with invalid data' do
          let(:body_attribute){ '' }

          it { should render_template('update') }
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

      it 'autentitication error' do
        expect(response.body).to eq 'You need to sign in or sign up before continuing.'
        expect(response.code).to eq '401'

      end
    end 
    
  end

  describe 'DELETE#destroy' do
    def delete_request(answer)
      xhr :post, :destroy, question_id: answer.question, id: answer
    end

    context 'authenticated user' do
      sign_in_user(:user)

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

        it { should render_template 'destroy' }

      end

      context 'when not owner' do
        it 'should not delete' do
          answer = create :answer

          expect{ delete_request(answer) }.not_to change{ 
            Answer.exists?(answer.id) 
          }

        end

      end
    end
    
    context 'no authenticated user' do
      before do
        sign_out :user
      end
      it 'should not delete answer' do
        answer = create :answer

        expect{ delete_request(answer) }.not_to change{ 
          Answer.exists?(answer.id)
        }
    
      end
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

