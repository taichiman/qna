require 'rails_helper'

describe QuestionsController do
  
  shared_examples 'only owner handling question' do |message|
    let(:question){ create :question }

    it { expect(response.body).to eq(t(message[:message])) }

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

    it { should render_template(:index) }

  end

  describe 'GET #edit' do
    let(:question){ create :question }
    
    it "authenticated user can not edit question by html request" do
      expect(get: "/questions/#{question.id}/edit" ).to_not be_routable

    end

  end

  describe 'PATCH #update' do
    sign_in_user(:user_with_questions) 
    
    let(:question){ user.questions.first }
    let(:title){ question.title }
    let(:body){ question.body }

    describe 'updates question' do      
      before do
        xhr :patch, :update, 
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
        it { should render_template('update') }

        it 'changes title of the question' do
          expect(Question.find(question.id).title).to eq(question.title.upcase)
        end
        it 'changes body of the question' do
          expect(Question.find(question.id).body).to eq(question.body.upcase)
        end
      end

      context 'with invalid attributes' do
        let(:title) { '' }
        
        it { should render_template 'update' }

        it 'not changes number of all questions' do
          expect{ xhr :patch, :update, 
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
        xhr :delete, :destroy, id: question
      end
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

      it 'removes the question from Question model', skip_request: true do
        xhr :delete, :destroy, id: question 
        expect{Question.find(question.id)}.to raise_error(ActiveRecord::RecordNotFound)

      end

      it { should render_template :destroy }

    end

    context 'when it has an answers' do

      it 'catches DeleteRestrictionError answer association exception', skip_request: true do
        expect{ xhr :delete, :destroy, id: question }.not_to raise_error

      end

      it 'does not delete question' do
        expect(Question.find(question.id)).to eq(question)

      end

      it { should render_template :destroy }

    end
        
    it_behaves_like 'only owner handling question', message: 'questions.destroy.only-owner-can-delete'
    
    describe 'when unauthenticated', skip_request: true do
      before do 
        sign_out user
        xhr :delete, :destroy, id: question
      end

      it { should respond_with 401 }

      it 'include devise failure message in response' do
        expect(response.body).to eq t('.devise.failure.unauthenticated')
      end
      
    end

  end

end

