class CreateAnswer < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :body
      t.belongs_to :question
    end
  end
end
