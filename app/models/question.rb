class Question < ActiveRecord::Base
  belongs_to :user

  has_many :answers, dependent: :restrict_with_exception
  has_many :attachments, as: :attachable
  has_many :votes, as: :votable
  has_many :vote_users, through: :votes, source: :user

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  validates :title, :body, presence: true

  scope :my, -> (user) { where( user: user) }

  def best_answer
    answers.where(best: true)
  end
  
  def answers_best_in_first
    answers.order(best: :desc, created_at: :asc)
  end

end

