class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :votable, :user, presence: true
  validates :vote_type, inclusion: { in: %w(up down) }

  def self.result_votes votable
    Vote.where(votable: votable, vote_type:'up').count - Vote.where( votable: votable, vote_type: 'down').count

  end

end

