require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:restrict_with_exception) }
  it { should have_many(:answers).dependent(:delete_all) }
  
  it { should have_many(:votes) }
  it { should have_many(:voted_questions).through(:votes) }
  it { should have_many(:voted_answers).through(:votes) }

  describe 'check owning' do
    let(:not_owner_user){ create :user }

    context 'for question' do
      let(:question){ create :question }
      let(:user){ question.user }

      it 'true when owner' do
        expect(user.owner_of?(question)).to be_truthy
      end

      it 'false when not owner' do
        expect(not_owner_user.owner_of?(question)).to be_falsy
      end
    
    end

    context 'for answer' do
      let(:answer){ create :answer }
      let(:user){ answer.user }

      it 'true when owner' do
        expect(user.owner_of?(answer)).to be_truthy
      end

      it 'false when not owner' do
        expect(not_owner_user.owner_of?(answer)).to be_falsy
      end
    
    end

  end
end

