class AddVoteTypeToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :vote_type, :string
    add_index :votes, :vote_type

  end
end
