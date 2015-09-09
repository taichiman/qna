class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions, dependent: :restrict_with_exception
  has_many :answers, dependent: :delete_all

  has_many :votes
  has_many :voted_questions, through: :votes, source: :votable, source_type: 'Question'
  has_many :voted_answers, through: :votes, source: :votable, source_type: 'Answer'

  def up_vote_for votable
    self.votes.up_for(votable).first

  end

  def down_vote_for votable
    self.votes.down_for(votable).first

  end

  def owner_of? object
    self.id == object.user_id
  end

  def voted_down_on? votable
    voted_on?(votable, 'down')

  end

  def voted_up_on? votable
    voted_on?(votable, 'up')

  end

  def vote_state_for votable
    Vote.vote_state self, votable

  end

  private

  def voted_on? votable, vote_type
    Vote.where(votable: votable, user: self, vote_type: vote_type).exists?

  end

end

