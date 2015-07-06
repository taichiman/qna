class AddDateFieldsToAnswers < ActiveRecord::Migration
  def change
    add_timestamps :answers, null: false
  end
end
