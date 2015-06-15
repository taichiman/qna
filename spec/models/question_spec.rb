require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body  }
  it { should have_many(:answers).dependent(:restrict_with_exception)}
  it { should belong_to(:user) } 

  describe 'check question owning' do
    let(:question){ create :question }

    context 'for logined user' do
      it 'true when owner' do
        expect(question.owner?(question.user)).to be_truthy
      end

      it 'false when not owner' do
        expect(question.owner?(create :user)).to be_falsy
      end
      
    end
    
    context 'for unauthenticated user' do
      it 'false always' do
        expect(question.owner?(nil)).to be_falsy

      end 

    end

  end

end
