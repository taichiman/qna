class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :votable, :user, presence: true

  def self.vote_result votable
    Vote.where(votable: votable, vote_type:'up').count - Vote.where( votable: votable, vote_type: 'down').count

  end

end

