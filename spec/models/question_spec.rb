require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body  }
  it { should have_many(:answers).dependent(:restrict_with_exception)}
  it { should belong_to(:user) } 

end
