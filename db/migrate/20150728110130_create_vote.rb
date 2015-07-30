class CreateVote < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, index: true
      t.references :user, index: true

    end
  end

end

