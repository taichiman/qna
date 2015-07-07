class AddQuestionIdToAttachment < ActiveRecord::Migration
  def change
    add_reference :attachments, :question, index: true

  end
end

