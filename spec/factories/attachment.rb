require 'tempfile'

FactoryGirl.define do
  factory :attachment do
    file { Tempfile.new('qna-attachment', 'tmp') }

    factory :attachment_with_question do
      transient do
        # when need an answer for the question
        add_answer_with_attachment false
      end

      attachable { create(:question) }

      after(:create) do |attachment, evaluator|
        if evaluator.add_answer_with_attachment
          attachment.attachable.answers << create(:attachment_with_answer).attachable
        end
      end

    end

    factory :attachment_with_answer do
      attachable { create(:answer) }
    end



  end
end

