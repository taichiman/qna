require 'rails_helper'

describe ApplicationHelper do

 it 'should shows name of user' do
    user = create 'user'

    expect(user_name(user)).to eq(user.email.partition('@').first)

  end
end

