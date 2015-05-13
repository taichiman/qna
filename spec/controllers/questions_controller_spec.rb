require 'rails_helper'

describe QuestionsController do
  
  shared_examples 'only owner handling question' do |message|
    let(:question){ create :question }

    it { should redirect_to my_questions_path }
    it { should set_flash[:alert].to(t(message[:message])) }

  end
  
  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'creates @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    sign_in_user

    context 'with valid attributes' do
      it 'creates a question' do
        expect{ post :create,
                  question: attributes_for(:question)
        }.to change(user.questions,:count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to(question_path(assigns(:question)))
      end
    end

    context 'with invalid attributes' do
      it 'does not create the question' do
        expect{ post :create,
                  question: attributes_for(:invalid_question)
        }.not_to change(Question, :count)
      end

      it 're-renders new view' do
        post :create,
          question: attributes_for(:question, title: nil)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #show" do
    let(:question) { create :question }
    before { get :show, id: question }

    it "assigns @question" do
      expect(assigns(:question)).to be_eql(question)
    end

    it "assigns @answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "render template :show" do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #my_questions' do
    before { create_pair :user_with_questions }

    sign_in_user :user_with_questions
    before{ get :index, scope: 'my' }

    it 'assigns @questions with only my questions' do
      expect(assigns(:questions)).to match_array(user.questions)
    end

    it { should render_template(:my_index) }

  end

  describe 'GET #edit' do
    sign_in_user(:user_with_questions)
    let(:question){ user.questions.first }
    
    before do
      get :edit, id: question
    end
    
    context 'user owns the edited question' do
      it { should use_before_action(:authenticate_user!) }
      it { should use_before_action(:set_question) }
      it 'assigns @question' do
        expect(assigns(:question)).to eq(question)
      end

      it { should render_template('edit') }

    end

    it_behaves_like 'only owner handling question', message: 'question-not-owner'

  end

  describe 'PATCH #update' do
    sign_in_user(:user_with_questions) 
    
    let(:question){ user.questions.first }
    let(:title){ question.title }
    let(:body){ question.body }

    describe 'updates question' do      
      before do
        patch :update, 
          id: question, 
          question: {
            title: title.upcase,
            body: body.upcase
          }
      end

      context 'with valid attributes' do
        it 'assigns @question' do
          expect(assigns(:question)).to eq(question)
        end
        it { should use_before_action(:authenticate_user!) }
        it { should use_before_action(:set_question) }
        it 'redirects to question show' do
          should redirect_to(question)
        end
        it { should set_flash[:notice].to t('questions.update.succesfully') }

        it 'changes title of the question' do
          expect(Question.find(question.id).title).to eq(question.title.upcase)
        end
        it 'changes body of the question' do
          expect(Question.find(question.id).body).to eq(question.body.upcase)
        end
      end

      context 'with invalid attributes' do
        let(:title) { '' }
        
        it { should render_template 'edit' }
        it { should set_flash[:alert].to t('questions.update.unsuccesfully') }

        it 'not changes number of all questions' do
          expect{ patch :update, 
                    id: question, 
                    question: {
                    title: title,
                    body: body }
          }.not_to change(Question, :count)
        end

        it 'does not changes title' do
          expect(Question.find(question.id).title).to eq(question.title)
        end

        it 'does not changes body' do                                       
          expect(Question.find(question.id).body).to eq(question.body)
        
        end
      end

      it_behaves_like 'only owner handling question', message: 'question-not-owner'

    end
  end

  describe 'DELETE #destroy' do
    sign_in_user(:user_with_questions)
    let(:question){ user.questions.first }

    before do |example|
      unless example.metadata[:skip_request]
        delete :destroy, id: question
      end
    end

    shared_examples 'redirect to my_questions path' do
      it { should redirect_to(my_questions_path) }
    end

    describe 'should has before filters' do
      it { should use_before_action(:authenticate_user!) }
      it { should use_before_action(:set_question) }
    end

    context 'when it has not an answers' do
      let!(:question) { create :question, user: user }
      
      it 'asigns @question' do
        expect(assigns(:question)).to eq(question)

      end

      it 'decreases number of questions', skip_request: true do
        expect{ delete :destroy,
                  id: question 
        }.to change(Question, :count).by(-1) 

      end

      it 'removes question from Question', skip_request: true do
        delete :destroy, id: question 
        expect{Question.find(question.id)}.to raise_error(ActiveRecord::RecordNotFound)

      end

      it_behaves_like 'redirect to my_questions path'

      it { should set_flash[:notice].to t('questions.destroy.deleted')}
    end

    context 'when it has an answers' do

      it 'catches DeleteRestrictionError answer association exception', skip_request: true do
        expect{ delete :destroy, id: question }.not_to raise_error

      end

      it 'does not delete question' do
        expect(Question.find(question.id)).to eq(question)

      end

      it_behaves_like 'redirect to my_questions path'

      it { should set_flash[:alert].to t('questions.destroy.not-deleted')}

    end
        
    it_behaves_like 'only owner handling question', message: 'questions.destroy.only-owner-can-delete'
    
    describe 'when unauthenticated', skip_request: true do
      before do 
        sign_out user
        delete :destroy, id: question
      end

      it { should redirect_to new_user_session_path }
      
    end

  end

end

