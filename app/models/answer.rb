class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable
  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  validates :body, presence: true

  scope :my, ->(user) { Answer.where(user: user) }

  has_many :votes, as: :votable
  has_many :vote_users, through: :votes, source: :user

  def select_as_best
    new_best = self
    old_best = self.question.best_answer.take
  
    old_best.try(:update, {best: false}) if old_best != new_best

    new_best.toggle!(:best)
    old_best

  end

end

