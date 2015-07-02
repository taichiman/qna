class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :my, ->(user) { Answer.where(user: user) }

  def select_as_best
    new_best = self
    old_best = self.question.best_answer.take
  
    old_best.try(:update, {best: false}) if old_best != new_best

    new_best.toggle!(:best)
    old_best

  end

  def owner? user
    if user.nil?
      false
    else
      self.user_id == user.id
    end

  end

end

