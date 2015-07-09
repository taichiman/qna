class Question < ActiveRecord::Base
  belongs_to :user

  has_many :answers, dependent: :restrict_with_exception
  has_many :attachments, as: :attachable
 
  accepts_nested_attributes_for :attachments

  validates :title, :body, presence: true

  scope :my, -> (user) { where( user: user) }

  def best_answer
    answers.where(best: true)
  end
  
  def answers_best_in_first
    answers.order(best: :desc, created_at: :asc)
  end

end

