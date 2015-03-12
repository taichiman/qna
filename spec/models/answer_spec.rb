require 'rails_helper'

RSpec.describe Answer do
  it { should validate_presence_of :body }
end
