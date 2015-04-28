require 'rails_helper'

describe QuestionsController do
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
    sign_in_user(:user_with_questions)
    let(:question){ user.questions.first }
    
    before do
      get :edit, id: question
    end
    
    context 'user owns the edited question' do
      it { should use_before_action(:authenticate_user!) }
      it { should use_before_action(:set_question) }
      it { expect(assigns(:question)).to eq(question) }
      it { should render_template('edit') }

    end

    context 'only owner should be able to edit the question' do
      let(:question){ create :question }

      it { should redirect_to my_questions_path }
      it { should set_flash[:notice].to(t('question-not-owner')) }

    end
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
        it { expect(assigns(:question)).to eq(question) }
        it { should use_before_action(:authenticate_user!) }
        it { should use_before_action(:set_question) }
        it { should redirect_to(question) }
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

      context 'tries update when not question owner' do
        let(:question){ create :question }

        it { should redirect_to(my_questions_path) }
        it { should set_flash[:notice].to t('question-not-owner') }

      end

    end
  end

end

