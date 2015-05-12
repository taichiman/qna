require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:restrict_with_exception) }
  it { should have_many(:answers).dependent(:delete_all) }
end

