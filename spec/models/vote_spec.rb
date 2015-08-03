require 'rails_helper'

describe Vote do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:votable) }

end

