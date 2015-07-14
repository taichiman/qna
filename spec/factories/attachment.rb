FactoryGirl.define do
  factory :attachment do
    file { File.new('spec/spec_helper.rb') }

    factory :attachment_with_question do
      attachable { create(:question) }
    end

    factory :attachment_with_answer do
      attachable { create(:answer) }
    end

  end
end

