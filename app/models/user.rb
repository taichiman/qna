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

  def owner_of? object
    self.id == object.user_id
  end

end

