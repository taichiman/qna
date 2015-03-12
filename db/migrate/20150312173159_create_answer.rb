class CreateAnswer < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :body
    end
  end
end
